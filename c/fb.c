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


//this function renders untextured triangles
void fun_2d61(){
	uint16_t *a = (uint16_t *)0xdbc4;

	if (a[0] == a[1]){
		return;
	}

	unsigned short s  = *(unsigned short *)0xdb10;
	char far *gameFb = MK_FP(s,0);

	uint16_t offset = a[0] << 2;

	int qtd = a[1] - a[0];
	int i;
	for(i = 0; i <= qtd; i++){
		int *tmp = (int *)(offset + 0xdbc8);
		int16_t iVar4 = tmp[0];
		int16_t iVar5 = tmp[1] - iVar4;

		if (iVar5 < 0) {
        iVar4 = iVar4 + iVar5;
        iVar5 = -iVar5;
      }

      iVar5++;

      uint16_t pbVar9 = offset * 0x50 + iVar4;

		void *something = (void *)0xdb12;//pixel? IDK
		char *p = something;
		if (*(uint16_t *)something < 0xf0f0) {
			char pc = p[0];
			int j;
			for(j = 0; j< iVar5; j++){
				gameFb[j + pbVar9] = pc;
			}
		}else{
			char ph = p[1];
			ph -= 0xf0;

			int j;
			for(j = 0; j< iVar5; j++){
				char pl = gameFb[pbVar9 + j];
				uint16_t px = pl + (ph << 8);
				char pc = *(char *)(px + 0x2e51);//some kind of pallete?
				gameFb[pbVar9 + j] = pc;
			}
		}

		offset += 4;
	}
}

