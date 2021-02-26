bits 16

%macro patchPoint 1
	incbin "code.bin",$,%1 - $
%endmacro
;params: originalSize, start
%macro padFunc 2
	times (%1 - ($ - %2)) nop ;pad with nops
%endmacro

patchPoint 0x46

mov bx, 0x154e
times 5 nop
;times 4 nop ;nops the call to dos interrupt 4Ah

patchPoint 0x58fc

;reimplementation of the function at 0x58fc
sbr: ; Start of a Bunch of Repeated instructions
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

padFunc 0x30, sbr


;write the rest of the file
incbin "code.bin",$
