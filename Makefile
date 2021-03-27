CFLAGS = -std=c99 -c -Wall -fno-stack-check -fnostdlib -march=i286 -mcmodel=m

default:
	rm ter.obj codep.bin ccode.obj || true

	nasm patchedcode.asm -f bin -o codep.bin
	nasm runterep.asm -f obj -o ter.obj

	owcc $(CFLAGS) -fo=ccode.obj c/fb.c

	wlink @link.lnk


