.text
.align 2
.thumb
.thumb_func
.global VariableMoney
/*
alter checkmoney and paymoney routines to load a variable if the money argument is 0x8003
	justification: probability of needing exactly $32771 is slim
*/

/* paymoney
	replace pointer at 15fbf8
*/
PayMain:
	push {r4, lr}
	mov r4, r0
	push {r4}
	bl ScriptReadWord	@money amount to check in r0 from script environment
	ldr r1, .val8003
	cmp r0, r1
	bne RegPayMoney
	ldr r1, .var8003
	ldrh r2, [r1]		@get money value from var8003
	b ReturnPayMoney
	
RegPayMoney:
	mov r2, r0
	
ReturnPayMoney:
	pop {r4}
	ldr r1, =(0x0806c162 +1)
	bx r1

.hword 0xfefe
/* checkmoney
	replace pointer at 15fbfc
*/
CheckMain:
	push {r4, lr}
	mov r4, r0
	push {r4}
	bl ScriptReadWord	@money amount to check in r0 from script environment
	pop {r4}
	ldr r1, .val8003
	cmp r0, r1
	bne RegCheckmoney
	ldr r1, .var8003
	ldrh r2, [r1]
	ldr r0, =(0x0806c196 +1)
	bx r0
	
RegCheckmoney:
	ldr r2, =(0x0806c194 +1)
	bx r2
	
ScriptReadWord:
	ldr r4, =(0x08069910 +1)
	bx r4

.align 2
.val8003:	.word 0x00008003
.var8003:	.word 0x020370be
