bits 16

segment code align=16
	incbin "codep.bin"


segment data align=16
	;I tried 62224 (0xF310) bytes and it worked
	incbin "data.bin"

segment stack class=stack
	;originally it was 0x400  (0x80  * 8)
	;now its           0x2000 (0x400 * 8)
	times 0x400 db "StackSeg"

segment code2
	resb 0x100 ;just to separate things

	..start:
	mov ax, 0x2000
	mov sp, ax

	;poor man's relocation
	mov ax, code
	mov fs, ax

	mov ax,  data
	mov [fs:0x53], ax
	mov [fs:0x568A], ax

	;I don't know what this magic number is, but the original code did this
	mov ax, 0xdfd8
	mov bp, ax

	;register clearing
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	xor esi, esi
	xor edi, edi
	;mov edi, 00270000h

	mov fs, ax
	mov gs, ax


	call code:0000h

	nop

	;DOS "terminate" function and return, this will never be reached, but keeps ghidra happy
	mov ah,0x4C
	int 0x21
	ret
