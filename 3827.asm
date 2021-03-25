00003827  8B36C4DB          mov si,[0xdbc4]
0000382B  8B3EC6DB          mov di,[0xdbc6]
0000382F  2BFE              sub di,si
00003831  0F84C200          jz near 0x38f7
00003835  47                inc di
00003836  C1E602            shl si,byte 0x2
00003839  06                push es
0000383A  A110DB            mov ax,[0xdb10]
0000383D  8EC0              mov es,ax
                             l383f:
0000383F  57                push di
00003840  8BFE              mov di,si
00003842  C1E702            shl di,byte 0x2
00003845  03FE              add di,si
00003847  C1E704            shl di,byte 0x4
0000384A  56                push si
0000384B  8B84C8DB          mov ax,[si-0x2438]
0000384F  8B8CCADB          mov cx,[si-0x2436]
00003853  8B9CE8DE          mov bx,[si-0x2118]
00003857  8B94EADE          mov dx,[si-0x2116]
0000385B  8BAC08E2          mov bp,[si-0x1df8]
0000385F  8BB40AE2          mov si,[si-0x1df6]
00003863  2BF5              sub si,bp
00003865  2BD3              sub dx,bx
00003867  2BC8              sub cx,ax
00003869  790E              jns 0x3879
0000386B  90                nop
0000386C  90                nop
0000386D  03C1              add ax,cx
0000386F  F7D9              neg cx
00003871  03DA              add bx,dx
00003873  F7DA              neg dx
00003875  03EE              add bp,si
00003877  F7DE              neg si
00003879  03F8              add di,ax
0000387B  41                inc cx
0000387C  660FB7C9          movzx ecx,cx
00003880  660FBFC2          movsx eax,dx
00003884  66C1E008          shl eax,byte 0x8
00003888  6699              cdq
0000388A  66F7F9            idiv ecx
0000388D  6696              xchg eax,esi
0000388F  660FBFC0          movsx eax,ax
00003893  66C1E008          shl eax,byte 0x8
00003897  6699              cdq
00003899  66F7F9            idiv ecx
0000389C  668BD0            mov edx,eax
0000389F  6687CE            xchg ecx,esi
000038A2  660FB7DB          movzx ebx,bx
000038A6  660FB7ED          movzx ebp,bp
000038AA  66C1E308          shl ebx,byte 0x8
000038AE  66C1E508          shl ebp,byte 0x8
000038B2  FC                cld
                             l38b3:
000038B3  66C1CB10          ror ebx,byte 0x10
000038B7  66C1CD10          ror ebp,byte 0x10
000038BB  66C1CE10          ror esi,byte 0x10
000038BF  8BF5              mov si,bp
000038C1  C1E608            shl si,byte 0x8
000038C4  648A00            mov al,[fs:bx+si]
000038C7  3CFF              cmp al,0xff
000038C9  740B              jz l38d6
000038CB  90                nop
000038CC  90                nop
000038CD  3CF0              cmp al,0xf0
000038CF  7327              jnc 0x38f8
000038D1  90                nop
000038D2  90                nop
000038D3  268805            mov [es:di],al
                             l38d6:
000038D6  47                inc di
000038D7  66C1C610          rol esi,byte 0x10
000038DB  66C1C310          rol ebx,byte 0x10
000038DF  66C1C510          rol ebp,byte 0x10
000038E3  6603D9            add ebx,ecx
000038E6  6603EA            add ebp,edx
000038E9  4E                dec si
000038EA  75C7              jnz l38b3
000038EC  5E                pop si
000038ED  5F                pop di
000038EE  83C604            add si,byte +0x4
000038F1  4F                dec di
000038F2  0F8549FF          jnz l383f
000038F6  07                pop es
000038F7  C3                ret
000038F8  2CF0              sub al,0xf0
000038FA  8AE0              mov ah,al
000038FC  268A05            mov al,[es:di]
000038FF  93                xchg ax,bx
00003900  8A9F512E          mov bl,[bx+0x2e51]
00003904  93                xchg ax,bx
00003905  268805            mov [es:di],al
00003908  EBCC              jmp l38d6
