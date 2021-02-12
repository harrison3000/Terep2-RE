; hello-DOS.asm - single-segment, 16-bit "hello world" program
;
; assemble with "nasm -f bin -o hi.com hello-DOS.asm"

bits 16

;segment data
;	incbin "01dd.bin"

segment code
	incbin "01ed.bin"

segment data align=16
	incbin "07ba.bin"


segment stack class=stack
	resb 8192
