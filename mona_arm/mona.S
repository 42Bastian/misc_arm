#define __ASM_INCLUDED__
#include <machine/arm/arm_asm.h>
#include <machine/arm/asm_trans.h>

	SYNTAX_UNIFIED

#define seed_high 0x7ec8
#define SCREEN_WIDTH 480
#define XOR_VALUE 0x04c11db7

	TEXT(.mona)

	EXPORT	mona

	// IN: r0 - frame buffer address
LABEL(mona)
	push	{r4-r9,lr}
	adr	r14,brush
	movs	r1,#63
	movs	r4,#0
	movw	r2,#XOR_VALUE & 0xffff
	movt	r2,#XOR_VALUE >> 16
	mov	r9,r0
	movt	r0,#seed_high
LABEL(l1)
	ldrh	r5,[r14],#2	// brush
	uxtb	r6,r5		// x = brush & 0xff
	uxtb	r7,r5,ror #8	// y = (brush >> 8)
	adds	r3,r1,#1
	lsls	r3,r3,#5	// 32*round pixels
	bfi	r0,r5,#0,#16	// seed = (seed & 0xffff0000)|brush;
LABEL(l2)
	lsls	r0,r0,#1
	itt	CS
	eorcs	r0,r0,r2
	andcs	r4,r0,#0x82	// r4 = direction
	lsrs	r5,r4,#7
	it	eq
	subeq	r5,r5,#1
	tst	r4,#2
	ite	eq
	subeq	r7,r7,r5
	subne	r6,r6,r5
	movs	r5,#0x7f
	ands	r6,r5
	ands	r7,r5
	movs.w	r5,#SCREEN_WIDTH
	muls	r5,r5,r7
	adds	r5,r5,r6
	and	r8,r1,#3
	cmp	r7,#95
	it	ls
	strbls	r8,[r9,r5]
LABEL(skip)
	subs	r3,r3,#1
	bne	l2
	subs	r1,r1,#1
	bne	l1
	pop	{r4-r9,pc}

LABEL(brush)
	DC16 0x030A, 0x37BE, 0x2F9B, 0x072B, 0x0E3C, 0xF59B, 0x8A91, 0x1B0B
	DC16 0x0EBD, 0x9378, 0xB83E, 0xB05A, 0x70B5, 0x0280, 0xD0B1, 0x9CD2
	DC16 0x2093, 0x209C, 0x3D11, 0x26D6, 0xDF19, 0x97F5, 0x90A3, 0xA347
	DC16 0x8AF7, 0x0859, 0x29AD, 0xA32C, 0x7DFC, 0x0D7D, 0xD57A, 0x3051
	DC16 0xD431, 0x542B, 0xB242, 0xB114, 0x8A96, 0x2914, 0xB0F1, 0x532C
	DC16 0x0413, 0x0A09, 0x3EBB, 0xE916, 0x1877, 0xB8E2, 0xAC72, 0x80C7
	DC16 0x5240, 0x8D3C, 0x3EAF, 0xAD63, 0x1E14, 0xB23D, 0x238F, 0xC07B
	DC16 0xAF9D, 0x312E, 0x96CE, 0x25A7, 0x9E37, 0x2C44, 0x2BB9, 0x2139

	END
