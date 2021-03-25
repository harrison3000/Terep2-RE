mov si,[0xdbc4]
mov di,[0xdbc6]
sub di,si
jz l38f7
inc di
shl si,byte 0x2
push es
mov ax,[0xdb10]
mov es,ax
 l383f:
push di
mov di,si
shl di,byte 0x2
add di,si
shl di,byte 0x4
push si
mov ax,[si-0x2438]
mov cx,[si-0x2436]
mov bx,[si-0x2118]
mov dx,[si-0x2116]
mov bp,[si-0x1df8]
mov si,[si-0x1df6]
sub si,bp
sub dx,bx
sub cx,ax
jns l3879
nop
nop
add ax,cx
neg cx
add bx,dx
neg dx
add bp,si
neg si
 l3879:
add di,ax
inc cx
movzx ecx,cx
movsx eax,dx
shl eax,byte 0x8
cdq
idiv ecx
xchg eax,esi
movsx eax,ax
shl eax,byte 0x8
cdq
idiv ecx
mov edx,eax
xchg ecx,esi
movzx ebx,bx
movzx ebp,bp
shl ebx,byte 0x8
shl ebp,byte 0x8
cld
 l38b3:
ror ebx,byte 0x10
ror ebp,byte 0x10
ror esi,byte 0x10
mov si,bp
shl si,byte 0x8
mov al,[fs:bx+si]
cmp al,0xff
jz l38d6
nop
nop
cmp al,0xf0
jnc l38f8
nop
nop
mov [es:di],al
 l38d6:
inc di
rol esi,byte 0x10
rol ebx,byte 0x10
rol ebp,byte 0x10
add ebx,ecx
add ebp,edx
dec si
jnz l38b3
pop si
pop di
add si,byte +0x4
dec di
jnz l383f
pop es
 l38f7:
ret
 l38f8:
sub al,0xf0
mov ah,al
mov al,[es:di]
xchg ax,bx
mov bl,[bx+0x2e51]
xchg ax,bx
mov [es:di],al
jmp l38d6
