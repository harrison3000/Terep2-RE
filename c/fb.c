#include <stdint.h>
#include <dos.h>

//reimplementation of the function at 0x2baa
void copyFramebuffer(){
	unsigned short s  = *(unsigned short *)0xdb10;
	unsigned short sv = 0xa000;

	char far *gameFb = MK_FP(s,0);
	char far *vgaFb  = MK_FP(sv,0);

	int32_t i;
	for (i = 0; i < 64000; i++){
		vgaFb[i] = gameFb[i];
	}
}
