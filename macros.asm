%macro patchPoint 1
	incbin codeBinName,$,%1 - $
	%%tmpLabl:
	%undef lastPP
	%xdefine lastPP %%tmpLabl
%endmacro

;pads the previous patch point to the given size
;params: originalSize
%macro padFunc 1
	times (%1 - ($ - lastPP)) nop ;pad with nops
%endmacro

%macro writeRemaining 0
	incbin codeBinName,$
%endmacro
