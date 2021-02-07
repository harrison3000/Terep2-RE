; hello-DOS.asm - single-segment, 16-bit "hello world" program
;
; assemble with "nasm -f bin -o hi.com hello-DOS.asm"

org  0x100        ; .com files always start 256 bytes into the segment
bits 16

jmp main

segment code align=16
code:
	incbin "01dd.bin"


%macro print 1
mov  dx, %1      ; the address of or message in dx
mov  ah, 9        ; ah=9 - "print string" sub-function
int  0x21         ; call dos services
%endmacro

exit:
	mov  ah, 0x4c     ; "terminate program" sub-function
	int  0x21         ; call dos services


%macro calcSeg 1
	mov ax, %1
	shr ax, $4
	push bx
	mov bx, cs
	add ax, bx
	pop bx
%endmacro


main:
	print msg

	mov ax, 0x01dd
	mov es, ax
	mov ds, ax

	mov si, code
	mov di, 0
	mov cx, 65024
	mmove:
		mov ax, [si]
		mov [di], ax
		add si, 2
		add di, 2
		dec cx ;we are moving words, not bytes
	loop mmove

	mov ax, 0x16eb
	mov ss, ax

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	jmp 0x01ed:0x0000


msg db 'Starting', 0x0d, 0x0a, '$'   ; $-terminated message

