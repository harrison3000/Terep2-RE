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

patchPoint 0x1c7
	call openFile
	padFunc 6

patchPoint 0x1e9
	call allocMem
	padFunc 4

patchPoint 0x202
	call closeFile
	padFunc 4

patchPoint 0x236
	mov byte [0x6e],1 ; enable the timer interrupt (otherwise it will just skip processing)
	call 0x257 ;main loop
	jmp 0x654 ;the only way to exit the loop is by pressing esc to break

	padFunc 0x257 - 0x236

patchPoint 0x25d
	;on main loop, originally a nop
	;a htl here it makes cpu usage a bit lower
	;may also help analysing hot functions and such
	;but ghidra doesn't like it

	nop
	;hlt

patchPoint 0x563
	;break on esc
	jnz afterRet
	ret
	nop
	afterRet:

;these instructions were patched at runtime just before the main loop
;ghidra didn't like it, so lets just write the correct value directly
patchPoint 0x56ba
	call 0x48d0
patchPoint 0x56c8
	call 0x500b

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

setMemSize:
	mov bx, 0x3000
	mov ah, 0x4a
	int 0x21
	ret

progEnd:
	incRange 0x1e, 0x46
	infiniteLoop
	ret

;I don't know what any of this does, but it calls a lot of dos interrupts
;it was disassembled using ndisasm
;seems to be related to segment allocations
allocateMemory:
	;tries to open sim.cfg
		mov dx,0x1a3d
		call openFile
		mov bx,ax
		jc lab0142 ;sim.cfg not found

		;sim.cfg found
		nop
		nop
		mov dx,0xe9e2
		mov cx,0x2
		call readFile
		mov dx,0xe9e4
		mov cx,0x2
		call readFile
		call closeFile
	lab0142:

		;memory allocations
		mov bx,0x1000
		call allocMem
		jc earlyEnd
		mov [0x1a45],ax
		mov gs,ax
		mov bx,0x1000
		call allocMem
		jc earlyEnd
		mov [0x1a47],ax
		mov fs,ax
		mov bx,0x1000
		call allocMem
		jc earlyEnd
		mov [0x1a49],ax
		mov bx,0x1000
		call allocMem
		jc earlyEnd
		mov [0x1a4b],ax
		ret
	earlyEnd:
		call progEnd
		ret


openFile:
	mov ax, 0x3d00
	int 0x21
	ret

closeFile:
	mov ah, 0x3e
	int 0x21
	ret

allocMem:
	mov ah, 0x48
	int 0x21
	ret

readFile:
	mov ah,0x3f
	int 0x21
	ret
