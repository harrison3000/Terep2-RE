bits 16

%define codeBinName "code.bin"

%include "macros.asm"

patchPoint 0x1e
	call progEnd
	infiniteLoop
	padFunc 0x46 - 0x1e

patchPoint 0x46
	;Sets the program block to 0x3000, originally 0x154e
	call setMemSize
	padFunc 0x52 - 0x46

patchPoint 0x11b
	call allocateMemory
	jmp end11b
	padFunc 0x17e - 0x11b
	end11b:

patchPoint 0x252
	jmp preLoop
	nop
	nop

patchPoint 0x563
	;break on esc
	jnz afterRet
	ret
	nop
	afterRet:

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

db "Sets memory size", 0
setMemSize:
	mov bx, 0x3000
	mov ah, 0x4a
	int 0x21
	ret

db "program end", 0
progEnd:
	incRange 0x1e, 0x46
	infiniteLoop
	ret

db "File related things", 0
;I don't know what any of this does, but it calls a lot of dos interrupts
;it was disassembled using ndisasm
;seems to be related to segment allocations
allocateMemory:
	;tries to open sim.cfg
		mov dx,0x1a3d
		mov al,0x0
		mov ah,0x3d
		int 0x21
		mov bx,ax
		jc lab0142 ;sim.cfg not found

		;sim.cfg found
		nop
		nop
		mov dx,0xe9e2
		mov cx,0x2
		mov ah,0x3f
		int 0x21
		mov dx,0xe9e4
		mov cx,0x2
		mov ah,0x3f
		int 0x21
		mov ah,0x3e
		int 0x21
	lab0142:

		;memory allocations
		mov ah,0x48
		mov bx,0x1000
		int 0x21
		jc earlyEnd
		mov [0x1a45],ax
		mov gs,ax
		mov ah,0x48
		mov bx,0x1000
		int 0x21
		jc earlyEnd
		mov [0x1a47],ax
		mov fs,ax
		mov ah,0x48
		mov bx,0x1000
		int 0x21
		jc earlyEnd
		mov [0x1a49],ax
		mov ah,0x48
		mov bx,0x1000
		int 0x21
		jc earlyEnd
		mov [0x1a4b],ax
		ret
	earlyEnd:
		call progEnd
		ret


db "pre loop", 0
preLoop:
	mov byte [0x6e],1
	call 0x257 ;main loop
	jmp 0x654 ;the only way to exit the loop is by pressing esc to break


