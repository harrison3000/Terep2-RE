bits 16

segment code align=16
	;must be 23760 (0x5CD0) bytes,
	incbin "code.bin"

segment data align=16
	;I tried 62224 (0xF310) bytes and it worked
	incbin "data.bin"

segment gstack
	;8192 bytes, seems to do the trick
	incbin "stack.bin"

segment code2
	..start:

	;poor man's relocation
	mov ax,  data
	mov [83 + 256], ax
	mov [0x568A + 256], ax

	mov ax, ds
	add ax, 0x154E
	mov [71 + 256], ax

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


	jmp code:0000h

segment mystack class=stack
	resb 8192
