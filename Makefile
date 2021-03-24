default:
	rm ter.obj codep.bin ccode.obj || true

	nasm patchedcode.asm -f bin -o codep.bin
	nasm runterep.asm -f obj -o ter.obj

	owcc -std=c99 -c -march=i286 -mcmodel=m -Wall -b=dos -fno-stack-check -fnostdlib -fo=ccode.obj c/fb.c

	wlink @link.lnk


