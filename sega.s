rom_start: 
	| Sega Genesis ROM header **************************************************************************	
	
	.long	0x00FFE000		| Initial stack pointer value
	.long	EntryPoint		| Start of our program in ROM
	.long	Interrupt		| Bus error
	.long	Interrupt		| Address error
	.long	Interrupt		| Illegal instruction
	.long	Interrupt		| Division by zero
	.long	Interrupt		| CHK exception
	.long	Interrupt		| TRAPV exception
	.long	Interrupt		| Privilege violation
	.long	Interrupt		| TRACE exception
	.long	Interrupt		| Line-A emulator
	.long	Interrupt		| Line-F emulator
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Spurious exception
	.long	Interrupt		| IRQ level 1
	.long	Interrupt		| IRQ level 2
	.long	Interrupt		| IRQ level 3
	.long	HBlank			| IRQ level 4 (horizontal retrace interrupt)
	.long	Interrupt		| IRQ level 5
	.long	VBlank			| IRQ level 6 (vertical retrace interrupt)
	.long	Interrupt		| IRQ level 7
	.long	Interrupt		| TRAP #00 exception
	.long	Interrupt		| TRAP #01 exception
	.long	Interrupt		| TRAP #02 exception
	.long	Interrupt		| TRAP #03 exception
	.long	Interrupt		| TRAP #04 exception
	.long	Interrupt		| TRAP #05 exception
	.long	Interrupt		| TRAP #06 exception
	.long	Interrupt		| TRAP #07 exception
	.long	Interrupt		| TRAP #08 exception
	.long	Interrupt		| TRAP #09 exception
	.long	Interrupt		| TRAP #10 exception
	.long	Interrupt		| TRAP #11 exception
	.long	Interrupt		| TRAP #12 exception
	.long	Interrupt		| TRAP #13 exception
	.long	Interrupt		| TRAP #14 exception
	.long	Interrupt		| TRAP #15 exception
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)
	.long	Interrupt		| Unused (reserved)

| Sega Genesis ROM Info **********************************************************************************	

	.ascii "SEGA MEGA DRIVE "									| Console name
	.ascii "(C)PB   2000.MAR"									| Copyrght
	.ascii "PON                                             "	| Domestic name
	.ascii "PONG                                            "	| International name
	.ascii "GM XXXXXXXX-XX"										| Version number
	.word 0x008100B4											| Checksum
	.ascii "JD              "									| I/O support
	.long rom_start												| ROM Start Address
	.long rom_end-1												| ROM End Address
	.long 0x00FF0000											| RAM Start Address
	.long 0x00FFFFFF											| RAM End Address
	.long 0x5241F820											| SRAM enabled
	.long 0x00200000											| SRAM Start Address
	.long 0x00200200											| SRAM End Address
	.ascii "                                        "			| Notes - 52 bytes
	.ascii "JUE             "									| Region codes (J=Japan, U=USA, E=Europe)

EntryPoint: 						|-- Our code starts here 
	tst.l   0x00a10008
	bne     SkipJoyDetect                               
	tst.w   0xa1000c
SkipJoyDetect:
	bne     SkipSetup
	lea     Table,a5                       
	movem.w (a5)+,d5-d7
	movem.l (a5)+,a0-a4                       
	move.b  -0x10ff(a1),d0          |Check Version Number                      
	andi.b  #0x000f,d0                             
	beq     WrongVersion                                   
	move.l  #0x0053454741,0x002f00(a1)   |Sega Security Code (SEGA)   
WrongVersion:
	move.w  (a4),d0
	moveq   #0x0000,d0                                
	movea.l d0,a6                                  
	move    a6,usp                                
	moveq   #0x0017,d1                | Set VDP registers
FillLoop:                           
	move.b  (a5)+,d5
	move.w  d5,(a4)                              
	add.w   d7,d5                                 
	dbra    d1,FillLoop                           
	move.l  (a5)+,(a4)                            
	move.w  d0,(a3)                                 
	move.w  d7,(a1)                                 
	move.w  d7,(a2)                                 
L0250:
	btst    d0,(a1)
	bne     L0250                                   
	moveq   #0x0025,d2                | Put initial vaules into a00000                
Filla:                                 
	move.b  (a5)+,(a0)+
	dbra    d2,Filla
	move.w  d0,(a2)                                 
	move.w  d0,(a1)                                 
	move.w  d7,(a2)                                 
L0262:
	move.l  d0,-(a6)
	dbra    d6,L0262                            
	move.l  (a5)+,(a4)                              
	move.l  (a5)+,(a4)                              
	moveq   #0x001f,d3                | Put initial values into c00000                  
Filc0:                             
	move.l  d0,(a3)
	dbra    d3,Filc0
	move.l  (a5)+,(a4)                              
	moveq   #0x0013,d4                | Put initial values into c00000                 
Fillc1:                            
	move.l  d0,(a3)
	dbra    d4,Fillc1
	moveq   #0x0003,d5                | Put initial values into c00011                 
Fillc2:                            
	move.b  (a5)+,0x000011(a3)        
	dbra    d5,Fillc2                            
	move.w  d0,(a2)                                 
	movem.l (a6),d0-d7/a0-a6                    
	move    #0x002700,sr                           
SkipSetup:
	bra     Continue
Table:
	dc.w    0x008000, 0x003fff, 0x000100, 0x0000a0, 0x000000, 0x0000a1, 0x001100, 0x0000a1
	dc.w    0x001200, 0x0000c0, 0x000000, 0x0000c0, 0x000004, 0x000414, 0x00302c, 0x000754
	dc.w    0x000000, 0x000000, 0x000000, 0x00812b, 0x000001, 0x000100, 0x0000ff, 0x00ff00                                   
	dc.w    0x000080, 0x004000, 0x000080, 0x00af01, 0x00d91f, 0x001127, 0x000021, 0x002600
	dc.w    0x00f977, 0x00edb0, 0x00dde1, 0x00fde1, 0x00ed47, 0x00ed4f, 0x00d1e1, 0x00f108                                   
	dc.w    0x00d9c1, 0x00d1e1, 0x00f1f9, 0x00f3ed, 0x005636, 0x00e9e9, 0x008104, 0x008f01                
	dc.w    0x00c000, 0x000000, 0x004000, 0x000010, 0x009fbf, 0x00dfff                                

Continue:
	tst.w    0x0000C00004

    move.l   #0x000,a7              | set stack pointer

	move.w  #0x002300,sr       | user mode

	lea     0x00ff0000,a0      | clear Genesis RAM
	moveq   #0,d0
clrram: move.w  #0,(a0)+
	subq.w  #2,d0
	bne     clrram

|Load driver into the Z80 memory        

	move.w  #0x00100,0x00a11100     | halt the Z80
	move.w  #0x00100,0x00a11200     | reset it

	lea     Z80Driver,a0
	lea     0x00a00000,a1
	move.l  #Z80DriverEnd,d0
	move.l  #Z80Driver,d1
	sub.l   d1,d0
Z80loop:
	move.b  (a0)+,(a1)+
	subq.w  #1,d0
	bne     Z80loop

	move.w  #0x000,0x00a11100       | enable the Z80

 | *****************************************************************************************************	      

	jmp      _main

Interrupt:    
	rte

|Do nothing for this demo  ******************************************************************************	
HBlank:
	rte

VBlank:
    addq.l   #1,vtimer
	rte

| Z80 Sound Driver  *************************************************************************************
Z80Driver:
	  dc.b  0x00c3,0x0046,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000
	  dc.b  0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000
	  dc.b  0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000
	  dc.b  0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000
	  dc.b  0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000
	  dc.b  0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000
	  dc.b  0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000
	  dc.b  0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000
	  dc.b  0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x00f3,0x00ed
	  dc.b  0x0056,0x0031,0x0000,0x0020,0x003a,0x0039,0x0000,0x00b7
	  dc.b  0x00ca,0x004c,0x0000,0x0021,0x003a,0x0000,0x0011,0x0040
	  dc.b  0x0000,0x0001,0x0006,0x0000,0x00ed,0x00b0,0x003e,0x0000
	  dc.b  0x0032,0x0039,0x0000,0x003e,0x00b4,0x0032,0x0002,0x0040
	  dc.b  0x003e,0x00c0,0x0032,0x0003,0x0040,0x003e,0x002b,0x0032
	  dc.b  0x0000,0x0040,0x003e,0x0080,0x0032,0x0001,0x0040,0x003a
	  dc.b  0x0043,0x0000,0x004f,0x003a,0x0044,0x0000,0x0047,0x003e
	  dc.b  0x0006,0x003d,0x00c2,0x0081,0x0000,0x0021,0x0000,0x0060
	  dc.b  0x003a,0x0041,0x0000,0x0007,0x0077,0x003a,0x0042,0x0000
	  dc.b  0x0077,0x000f,0x0077,0x000f,0x0077,0x000f,0x0077,0x000f
	  dc.b  0x0077,0x000f,0x0077,0x000f,0x0077,0x000f,0x0077,0x003a
	  dc.b  0x0040,0x0000,0x006f,0x003a,0x0041,0x0000,0x00f6,0x0080
	  dc.b  0x0067,0x003e,0x002a,0x0032,0x0000,0x0040,0x007e,0x0032
	  dc.b  0x0001,0x0040,0x0021,0x0040,0x0000,0x007e,0x00c6,0x0001
	  dc.b  0x0077,0x0023,0x007e,0x00ce,0x0000,0x0077,0x0023,0x007e
	  dc.b  0x00ce,0x0000,0x0077,0x003a,0x0039,0x0000,0x00b7,0x00c2
	  dc.b  0x004c,0x0000,0x000b,0x0078,0x00b1,0x00c2,0x007f,0x0000
	  dc.b  0x003a,0x0045,0x0000,0x00b7,0x00ca,0x004c,0x0000,0x003d
	  dc.b  0x003a,0x0045,0x0000,0x0006,0x00ff,0x000e,0x00ff,0x00c3
	  dc.b  0x007f,0x0000
Z80DriverEnd:


