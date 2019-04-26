Pong by [Pascal Bosquet][6] 
====================================================================================
Original code can be found here -> (http://www.pascalorama.com/megadrive-m68000-programming/)

Just me poking around Pascal Bosquet's code to get this running in GNU Assembly (GAS).  I'm currently learning the M68000 and Mega Drive/Genesis programming, this code just took a bit figuring out how the header should look like and getting the make file just right. I don't see a lot of newer examples online using GAS, figured others would find this useful so I decided to put this on Github.
   
If you don't have a tool chain installed already, I have a script for [Linux][1] or [Windows][2] to get you set up.  There are also [SGDK][4] and [Marsdev][5] as options if you want to code in C instead of GNU Assembly. 

For debugging, I use [Blast 'Em][3].  Modify the makefile to use whatever emulator you like.

[1]: https://gist.github.com/WillSams/c4cbf6235b467d8b595693969342237e
[2]: https://gist.github.com/WillSams/f592f9d494b51119945440f7e91079b0
[3]: https://www.retrodev.com/blastem/
[4]: https://github.com/Stephane-D/SGDK
[5]: https://github.com/andwn/marsdev
[6]: https://github.com/pascalorama

