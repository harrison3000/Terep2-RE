bits 16

segment code align=16
	;must be 23760 (0x5CD0) bytes,
	incbin "codep.bin"


segment data align=16
	;I tried 62224 (0xF310) bytes and it worked
	incbin "data.bin"

segment gstack
	;8192 bytes, seems to do the trick
	incbin "stack.bin"

segment code2
	..start:

	;poor man's relocation
	mov ax, code
	mov fs, ax

	mov ax,  data
	mov [fs:0x53], ax
	mov [fs:0x568A], ax

	;I don't know what this magic number is, but the original code did this
	mov ax, 0xdfd8
	mov bp, ax

	mov ax, gstack
	mov ss, ax

	mov eax, 0x00000400
	mov esp, eax

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

segment mystack class=stack
	resb 8192
