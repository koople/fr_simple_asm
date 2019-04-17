.text
.align 2
.thumb
.thumb_func
.global ChangePokeNames
/*
If player's name is changed during game, this changes all pokemon with matching OTIDs to your new name

Inputs: 
	-none
Outputs: 
	-none

Usage:
	callasm 0x809FC91  //rename player
	waitstate
	callasm [this_routine]+1
  
Instructions:
  1. compile this routine with a thumb compiler
  2. insert into free space at an offset ending with 0, 4, 8, or C
  3. eg. if I insert at 0x950000, I would call it with 'callasm 0x8950001'
*/

Start:
	push {r0-r7, lr}

ChangePartyNames:
	ldr r7, .PartyPoke
	mov r6, #0x64
	mov r5, #0x5	
	bl NameChanges

ChangeBoxNames:
	ldr r7, .BoxDMA
	ldr r7, [r7]
	add r7, #0x4
	mov r6, #0x50
	mov r5, #0x69
	lsl r5, r5, #0x2		@420 box pokemon total
	bl NameChanges
	
Exit:
	pop {r0-r7, pc}
	
	
/*
Name Change Call Function
	r5 = num pokes to check
	r6 = data size per poke
	r7 = start address
*/	
NameChanges:
	push {lr}
	mov r4, #0x0	
	
OuterLoop:
	mov r0, r4
	mul r0, r6
	
GetPokeDataLoc:
	add r0, r0, r7	
	ldrh r1, [r0, #0x4]	
	
GetPlayerID:
	ldr r2, .Saveblock
	ldr r3, [r2]
	ldrh r2, [r3, #0xA]	
	
CompareIDs:
	cmp r1, r2
	bne OuterLoopRestart		@OTIDs do not match -> no name change
	
PrepInnerLoop:
	add r0, #0x14
	mov r2, #0x0	
	
charLoop:
	ldrb r1, [r3]
	strb r1, [r0]
	cmp r2, #0x6		@7 bytes for OT name
	beq OuterLoopRestart
	add r3, #0x1
	add r0, #0x1
	add r2, #0x1
	b charLoop

OuterLoopRestart:
	cmp r4, r5
	beq Return
	add r4, #0x1
	b OuterLoop

Return:
	pop {r0}
	bx r0

	
.align 2
.PartyPoke:	.word 0x02024284
.Saveblock:	.word 0x0300500C
.BoxDMA:	.word 0x03005010
