.include "sega.s"

_main:

*---< Variable defining ram start at 0x00FF000>

.set vtimer		,         0x00ff0000       | long
.set ballx		,         vtimer+4      | word
.set bally		,         ballx+2       | word
.set ballpx		,         bally+2       | word
.set ballpy		,         ballpx+2      | word
.set x1			,         ballpy+2      | word
.set y1			,         x1+2          | word
.set x2			,         y1+2          | word
.set y2			,         x2+2          | word


* .include " Megadrive related stuff

        .include "genesis.dat"
        
*        move.w      sr,-(sp)            | disable interrupt
*        or.w        #0x00700,sr

*---< Init the GFX >

        lea         GFXCTRL,a0          | GFX Control
        move        #0x008016,(a0)         | reg. 80, Enable Hor. Sync
        move        #0x008174,(a0)         | reg. 81, Enable Ver. Sync + Fast transfer
        move        #0x008238,(a0)         | reg. 82, A plane left half location = 0x00E000
        move        #0x008338,(a0)         | reg. 83, A plane right half location = 0x00E000
        move        #0x008407,(a0)         | reg. 84, B plane location = 0x00E000
        move        #0x008560,(a0)         | reg. 85, Sprite data table 0x00C000
        move        #0x008600,(a0)         | reg. 86, ?
        move        #0x008700,(a0)         | reg. 87, Background color #0
        move        #0x008801,(a0)         | reg. 88, ?
        move        #0x008901,(a0)         | reg. 89, ?
        move        #0x008a01,(a0)         | reg. 8a, 
        move        #0x008b00,(a0)         | reg. 8b, 
        move        #0x008c00,(a0)         | reg. 8c, Hilight diabled , 32 cells mode
        move        #0x008d08,(a0)         | reg. 8d, 
        move        #0x008f02,(a0)         | reg. 8f, 
        move        #0x009000,(a0)         | reg. 90,
        move        #0x009100,(a0)         | reg. 91,
        move        #0x0092ff,(a0)         | reg. 92,

*---< Fill the  palette  >

        move.l     #0x00c0000000,GFXCTRL  
        move.w     #0x000000,GFXDATA       | Black
        move.w     #0x000EEE,GFXDATA       | White

*----< Load the Tile >

        move.l     #0x0040000000,GFXCTRL
        move.w     #15,d0               | size of the tile : (1 long * 8 )*2 tile
        lea        tiledata,a0
loopt:  move.l     (a0)+,GFXDATA
        dbf        d0,loopt

*        move.w      (sp)+,sr            | enable interrupt

*----< Init the variables >

        jsr        port_setup           | initialize the joypad port

init:

* P1 :
        move.w     #0x0080,x1              | 0
        move.w     #204,y1              | 

* P2 :
        move.w     #376,x2              | 
        move.w     #204,y2              | 
        
* the ball :

        move.w     #0x0088,ballx
        move.w     #220,bally
        move.w     #1,ballpx
        move.w     #1,ballpy

*----< the main loop >

loop:  nop

* moving pal1

        bsr        porta                  | test joypad#1 DOWN
        cmp.w      #JOY_DOWN,d0            
        bne        EIJD1 
        add.w      #2,y1
EIJD1:  nop                               
        cmp.w      #JOY_UP,d0             | test joypad#1 UP
        bne        EIJU1 
        sub.w      #2,y1
EIJU1:  nop

        cmp.w      #0x0080,y1                | if y1<0 -> y1=0
        bgt        ELYT
        move.w     #0x0080,y1
ELYT:   nop

        cmp.w      #280,y1                | if y1>280 -> y1=280
        blt        EHYT
        move.w     #280,y1
EHYT:   nop


* moving pal2 : by computer

        move.w     bally,y2               | pal2 is control by the ball

        cmp.w      #0x0080,y2                | if y2<0 -> y2=0
        bgt        ELY2T
        move.w     #0x0080,y2
ELY2T:  nop

        cmp.w      #280,y2                | if y2>280 -> y2=280
        blt        EHY2T
        move.w     #280,y2
EHY2T:  nop

* moving the ball

        move.w     ballpx,d0        | X moving
        add.w      d0,ballx

        move.w     ballpy,d0        | Y moving
        add.w      d0,bally

        cmp.w      #312,bally       | y>312 -> rebound
        bge        IFYGE
        bra        EYGE
IFYGE:  move.w     #312,bally
        neg.w      ballpy
EYGE:   nop
        cmp.w      #0x0080,bally       | y<0 -> rebound 
        ble        IFYLE
        bra        EYLE
IFYLE:  move.w     #0x0080,bally
        neg.w      ballpy
EYLE:   nop

* test collision with the raquette 1 (remember the raq1 is 4 Tile lenght)

        cmp.w      #0x0088,ballx       | if x<0x0088 then init  init all p2 score 1
        bgt        EXGZERO          | cool nothing to do

        move.w     y1,d0            | if bally>y1 -> cool, it"s the raq1
        sub.w      #7,d0            | there"s a little delta y colission of 7 pixels
        cmp.w      bally,d0
        bgt        init             | P2 score

        move.w     y1,d0
        add.w      #39,d0           | the raq is 4 tile 4*8=32 + 7 pixels delta
        cmp.w      bally,d0
        ble        init             | P2 score

        move.w     ballpx,d0        | ok, i"ve a collision -> -ballpx
        neg.w      ballpx
        move.w     #0x0088,ballx

EXGZERO:

* test collision with the raquette 2 (remember the raq is 4 Tile lenght)

        cmp.w      #368,ballx       | if x>368 then init  init all, p1 score 1
        ble        EXGZERO2         | cool nothing to do

        move.w     y2,d0            | it"s the raq2 baby
        sub.w      #7,d0            | there"s a little delta y colission
        cmp.w      bally,d0
        bgt        init             | P1 score

        move.w     y2,d0
        add.w      #39,d0           | the raq is 4 tile 4*8=32 + 7 pixel delta
        cmp.w      bally,d0
        ble        init             | P1 score

        move.w     ballpx,d0        | ok, i"ve a collision -> -ballpx
        neg.w      ballpx
        move.w     #368,ballx

EXGZERO2:


* displaying the ball

        move.l     #0x0040000003,GFXCTRL     | Write to 0x00C000 Sprite list    

        move.w     bally,GFXDATA          | Y
        move.w     #0x001,GFXDATA            | 8 * 8 sprite : next sprite=1
        move.w     #0x001,GFXDATA            | Tile 1
        move.w     ballx,GFXDATA          | X

* displaying raquettes

        clr.w      d0                     | for counter loop
        move.w     y1,d1                  | for several tile display per palette
        move.w     #2,d2                  | next sprite for the sprite list
               
forloop1:
        addq.b     #1,d0

        move.w     d1,GFXDATA             | Y
        move.w     d2,GFXDATA             | next for the sprite list, size=0
        move.w     #1,GFXDATA             | Tile number
        move.w     x1,GFXDATA             | X

        add.w      #1,d2
        add.w      #8,d1                  

        cmp.b      #4,d0                  | the raq is 4 tile lenght
        ble        forloop1

* Raquette 2
        clr.w      d0
        move.w     y2,d1                  | for several tile display per palette
               
forloop2:
        addq.b     #1,d0

        move.w     d1,GFXDATA             | Y
        move.w     d2,GFXDATA             | next for the sprite list, size=0
        move.w     #1,GFXDATA             | Tile number
        move.w     x2,GFXDATA             | X

        add.w      #1,d2
        add.w      #8,d1                  

        cmp.b      #4,d0                  | the raq is 4 tile lenght
        ble        forloop2


        bsr vsync                         | wait for vsync 

        bra loop                          | infinite loop


* Wait for vsync by Paul Lee

vsync:
       	move.l      vtimer,d0
vsloop:
		cmp.l       vtimer,d0
       	beq         vsloop
       	rts

* .include " title and Joypad sub routine

       .include "joy.s"
       .include "tile.dat"

rom_end:    				|Very last line, end of ROM address 
