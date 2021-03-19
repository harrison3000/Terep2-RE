bits 16

%define codeBinName "codep.bin"
%include "macros.asm"

segment code align=16
	..start:

	patchPoint 0x52
	mov ax, originalData

	patchPoint 0x5689
	mov ax, originalData

	writeRemaining


segment originalData align=16
	;I tried 62224 (0xF310) bytes and it worked
	incbin "data.bin"

segment stack class=stack
	;originally it was 0x400  (0x80  * 8)
	;now its           0x2000 (0x400 * 8)
	times 0x400 db "StackSeg"
