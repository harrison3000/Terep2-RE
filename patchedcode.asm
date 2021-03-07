bits 16

%define codeBinName "code.bin"

%include "macros.asm"

patchPoint 0x1e
	;this was a simple code reached by a jump, I transformed it into a call to help ghidra
	;make more sense of the code
	call earlyEnd
	infiniteLoop
	padFunc 0x46 - 0x1e

patchPoint 0x46
	;Sets the program block to 0x3000, originally 0x154e
	call setMemSize
	padFunc 0x52 - 0x46

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

db "early end", 0
earlyEnd:
	incRange 0x1e, 0x46
	ret

db "Sets memory size", 0
setMemSize:
	mov bx, 0x3000
	mov ah, 0x4a
	int 0x21
	ret
