; hello-DOS.asm - single-segment, 16-bit "hello world" program
;
; assemble with "nasm -f bin -o hi.com hello-DOS.asm"

org  0x100        ; .com files always start 256 bytes into the segment
bits 16

jmp main


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
	calcSeg oridata
	mov ds, ax
	mov es, ax
	calcSeg code
	;TODO use far jump?
	push ax
	push 0x0000
	retf


msg db 'Starting', 0x0d, 0x0a, '$'   ; $-terminated message


segment oridata align=16
oridata:
	incbin "oridata.bin"

segment code align=16
code:
	incbin "code.bin"

