bits 16

%define codeBinName "code.bin"

%include "macros.asm"

patchPoint 0x46

	;this is the size of the program
	;the memory block will be limited to this and new blocks will be created
	;originally 0x154e
	mov bx, 0x3000
	times 5 nop

;reimplementation of the function at 0x58fc
;seems to be sound related, If you imediately return the game becomes muted
patchPoint 0x58fc

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

	padFunc 0x30


writeRemaining

;================ORIGINAL END===============
