* Joypad support functions by Paul Lee

*-------------------------------------------------------------------------
*
*       Setup the port registers to read joysticks.
*
*-------------------------------------------------------------------------

port_setup:
                moveq       #0x40,d0
                move.b      d0,0xA10009    |$a10009 
                move.b      d0,0xA1000B    |$a1000b
                move.b      d0,0xA1000D    |$a1000d
                rts

*-------------------------------------------------------------------------
*
*       Check for input from Joypad 1.
*
*       Input:
*               None
*       Output:
*               Status of Joypad 1
*       Registers used:
*               d0, d1
*
*-------------------------------------------------------------------------

porta:
                moveq       #0,d0
                move.b      #0x40,0xA10009   |$a10003
                nop
                nop
                move.b      0xA10003,d1
                andi.b      #0x3F,d1
                move.b      #0,0xA10009      |$a10003
                nop
                nop
                move.b      0xA10009,d0
                andi.b      #0x30,d0
                lsl.b       #2,d0
                or.b        d1,d0
                not.b       d0
                rts
