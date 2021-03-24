bits 16

%define codeBinName "codep.bin"
%include "macros.asm"

%macro cFunc 2
	patchPoint %1
	call far %2
	ret
%endmacro

segment code align=16
	extern copyFramebuffer_
	extern fun_3f98_
	extern fun_2d61_

	..start:

	patchPoint 0x52
	mov ax, originalData

	cFunc 0x2baa, copyFramebuffer_

	cFunc 0x2d61, fun_2d61_

	cFunc 0x3f98, fun_3f98_

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
