#include <stdint.h>
#include <dos.h>

//reimplementation of the function at 0x2baa
void copyFramebuffer(){
	unsigned short s  = *(unsigned short *)0xdb10;
	unsigned short sv = 0xa000;

	char far *gameFb = MK_FP(s,0);
	char far *vgaFb  = MK_FP(sv,0);

	uint16_t i;
	for (i = 0; i < 64000; i++){
		vgaFb[i] = gameFb[i];
	}
}

//seems to be related to the printing of the credits
//returning imediately from this function makes the text disapear
//a and b seems to be screen coordinates
#pragma aux fun_3f98 parm [ax] [bx] [cx];
void fun_3f98(uint16_t a, uint16_t b, char c){
	uint16_t *alim = (uint16_t *)0xdbc0;
	uint16_t *blim = (uint16_t *)0xdbbc;

	int ainterval = (a >= alim[0]) && (a <= alim[1]);
	int binterval = (b >= blim[0]) && (b <= blim[1]);

	if(ainterval && binterval){
		//TODO make function to get this gameFb pointer
		unsigned short s  = *(unsigned short *)0xdb10;
		char far *gameFb = MK_FP(s,0);

		uint16_t i = a;

		uint16_t b2 = b << 8;
		i += b2;

		b2 >>= 2;
		i += b2;

		gameFb[i] = c;
	}
}
