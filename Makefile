default:
	nasm patchedcode.asm -f bin -o codep.bin
	nasm runterep.asm -f obj -o ter.obj
	wlink @link.lnk


