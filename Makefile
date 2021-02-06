default:
	nasm runterep.asm -f bin -o run.com
	cat run.com 01ed.bin > terep.com

