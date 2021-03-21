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
cmp word [0xdb12],0xf0f0
jnc lPart2
nop
nop
	loop1:
mov di,si
shl di,byte 0x2
add di,si
shl di,byte 0x4
mov ax,[si-0x2438]
mov cx,[si-0x2436]
sub cx,ax
jns l2da1
nop
nop
add ax,cx
neg cx
	l2da1:
inc cx
add di,ax
cld
mov ax,[0xdb12]
shr cx,1
rep stosw
jnc l2db1
nop
nop
stosb
	l2db1:
add si,byte +0x4
dec dx
jnz loop1
pop es
	lRet:
ret
	lPart2:
mov bx,[0xdb12]
sub bh,0xf0
	l2dc0:
mov di,si
shl di,byte 0x2
add di,si
shl di,byte 0x4
mov ax,[si-0x2438]
mov cx,[si-0x2436]
sub cx,ax
jns l2ddc
nop
nop
add ax,cx
neg cx
	l2ddc:
inc cx
add di,ax
cld
	loopsto:
mov bl,[es:di]
mov al,[bx+0x2e51]
stosb
loop loopsto
add si,byte +0x4
dec dx
jnz l2dc0
pop es
ret
