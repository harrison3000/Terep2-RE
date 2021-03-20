default:
	rm ter.obj codep.bin ccode.obj || true

	nasm patchedcode.asm -f bin -o codep.bin
	nasm runterep.asm -f obj -o ter.obj

	wcc -5 -mm -wx -s -zls -fo=ccode.obj c/fb.c

	wlink @link.lnk


