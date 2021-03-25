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

patchPoint 0x57
	;skip the XMS things
	;it seems the game doesn't use it, it just alocates, tests and dealocates 🤷
	;putting the CPU in unreal mode had the side effect of making dosbox enter dynamic 100% mode
	;with this skip it has to be set manually... however it's worth it from a reverse engineering point of view
	call 0xdc
	jmp 0x120

patchPoint 0x11b
	ret

patchPoint 0x120
	call allocateMemory
	jmp 0x160

patchPoint 0x160
	call 0x24c0
	call 0x255c
	call 0x184 ;"new" func, car loading loop
	jmp 0x21c

patchPoint 0x170
	ret

patchPoint 0x1ad
	jc 0x170

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

	;the only way to exit the loop is by pressing esc to break,
	;0x1e is not a clean exit, but this is dosbox, who cares?
	jmp 0x1e



patchPoint 0x25d
	;on main loop, originally a nop
	;a htl here it makes cpu usage a bit lower
	;may also help analysing hot functions and such
	;but ghidra doesn't like it

	nop
	;hlt

patchPoint 0x327
	call 0x5831
	nop

patchPoint 0x3f3
	call 0x5831
	nop

patchPoint 0x4b3
	call 0x5831
	nop

patchPoint 0x563
	;break on esc
	jnz afterRet
	ret
	nop
	afterRet:


patchPoint 0x2467
	call openFile
	padFunc 6

patchPoint 0x2478
	call readFile
	padFunc 4

patchPoint 0x247e
	call closeFile
	padFunc 4

patchPoint 0x24e4
	call openFile
	padFunc 6

patchPoint 0x24f9
	call lseekEnd
	padFunc 5

patchPoint 0x2508
	call readFile
	padFunc 4

patchPoint 0x2512
	call lseekBeg
	padFunc 5

patchPoint 0x2524
	call closeFile
	padFunc 4

patchPoint 0x252b
	call openFile
	padFunc 6

patchPoint 0x2539
	call readFile
	call closeFile
	padFunc 8

patchPoint 0x2544
	call openFile
	padFunc 6

patchPoint 0x2552
	call readFile
	call closeFile
	padFunc 8

patchPoint 0x3827
	call new3827
	ret

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

patchPoint 0x5a62
	call openFile
	padFunc 6

patchPoint 0x5a7b
	call lseekBeg
	padFunc 5

patchPoint 0x5a8b
	call closeFile
	padFunc 4

patchPoint 0x5a9b
	call readFile
	padFunc 4

patchPoint 0x5b38
	call readFile
	padFunc 4

writeRemaining

;================ORIGINAL END===============

setMemSize:
	mov bx, 0x3000
	mov ah, 0x4a
	int 0x21
	ret

progEnd:
	mov ax, 0x4c00
	int 0x21
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

lseekEnd:
	mov ax,0x4202
	int 0x21
	ret

lseekBeg:
	mov ax,0x4200
	int 0x21
	ret

new3827:
%include "3827.asm"
