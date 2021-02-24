bits 16

segment code align=16
	;must be 23760 (0x5CD0) bytes,
	incbin "code.bin",0,0x58fc

	;reimplementation of the function at 0x58fc
	sbr: ; Start of a Bunch of Repeated instructions
	push ax
	xchg ah,al
	mov dx, 0x388
	out dx, al

	push ecx

	mov ecx, 6
	lab1:
	in al,dx
	loop lab1

	inc dx		;0x5909
	mov al,ah	;0x590a
	out dx,al	;0x590c

	mov ecx, 28
	lab2:
	in al,dx
	loop lab2

	;0x5929
	dec dx
	pop ecx
	pop ax
	ret

	;0x30 is the size of the original function
	times (0x30 - ($ - sbr)) nop ;pad with nops

	incbin "code.bin",$


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
	mov [0x53 + 0x100], ax
	mov [0x568A + 0x100], ax

	mov ax, ds
	add ax, 0x154E
	mov [0x47 + 0x100], ax

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

segment mystack class=stack
	resb 8192
