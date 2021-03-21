	mov bx,[0xdbc4]
	mov dx,[0xdbc6]
	sub dx,bx
	jz lRet
	nop
	nop
	inc dx
	shl bx,byte 0x2
	push es
	mov ax,[0xdb10]
	mov es,ax
	mov si,bx

	nop
	nop


fLoop:
	mov di,si
	shl di,byte 0x2
	add di,si
	shl di,byte 0x4
	mov ax,[si-0x2438]
	mov cx,[si-0x2436]
	sub cx,ax
	jns nltz
	nop
	nop
	add ax,cx
	neg cx
nltz:
	inc cx
	add di,ax
	cld

	nop
	cmp word [0xdb12],0xf0f0
	jnc lPath2
	nop
	mop

	;Path1

	mov ax,[0xdb12]
	shr cx,1
	rep stosw
	jnc l2db1
	nop
	nop
	stosb

	jmp endif

	;Path2
lPath2:
	;these 2 insts were executed outside the loop before, but it doesn't matter here
	;I want easier understanding, not speed, it will be fast anyway
	mov bx,[0xdb12]
	sub bh,0xf0

loopsto:
	mov bl,[es:di]
	mov al,[bx+0x2e51]
	stosb
	loop loopsto

	jmp endif
	nop

endif:

l2db1:
	add si,byte +0x4
	dec dx
	jnz fLoop
	pop es
lRet:
	ret
