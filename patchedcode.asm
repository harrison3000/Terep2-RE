bits 16


%macro patchPoint 1
	incbin "code.bin",$,%1 - $
	%%tmpLabl:
	%undef lastPP
	%xdefine lastPP %%tmpLabl
%endmacro

;pads the previous patch point to the given size
;params: originalSize
%macro padFunc 1
	times (%1 - ($ - lastPP)) nop ;pad with nops
%endmacro

patchPoint 0x46

mov bx, 0x154e
times 5 nop


;reimplementation of the function at 0x58fc
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


;write the rest of the file
incbin "code.bin",$
