Pong by by Pascal Bosquet 
====================================================================================
Original code can be found here -> (http://www.pascalorama.com/megadrive-m68000-programming/)

Just me poking around Pascal Bosquet's code to get this running in GNU Assembly (GAS).  I'm currently learning the M68000 and Mega Drive/Genesis programming, this code just took a bit figuring out how the header should look like and getting the make file just right. I don't see a lot of newer examples online using GAS, figured others would find this useful so I decided to put this on Github.
   
If you don't have a tool chain installed you can install binutils using [my tools setup][1] or use the [SGDK toolchain][2].  If you are using the SGDK toolchain, just modify the GENDEV variable and targets in the Makefile to conform to your setup.

For debugging, use [DGen][3].  To install DGen from source, follow these instructions:

	cd $TEMPBUILDDIR/tools
	git clone git://git.code.sf.net/p/dgen/dgen dgen-dgen
	cd $TEMPBUILDDIR/tools/dgen-dgen
	./autogen.sh && ./configure
	make && make install
	chmod +x dgen

[1]: https://gist.github.com/WillSams/ed5d01919095021397fa90e7dfbacb75
[2]: https://github.com/Stephane-D/SGDK
[3]: http://dgen.sourceforge.net



