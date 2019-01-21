.text
.align 2
.thumb
.thumb_func
.global LoadBacksprite
/*
-edit JPANs backsprite hack to fix trainer/player palettes
-load 4 frames instead of 5 to save some space in the ROM
-remove BIOS dependability

-replace 'first_male_back' with location of default backsprite

ptr at 7630
*/

.equ offset, 0xYYYYYY		@ where to insert
.equ romsize, 0x08000000

.org 0x762A, 0xff
.byte 0x1, 0x49, 0x8, 0x47, 0x0, 0x0
.word offset+romsize+1

.org offset, 0xff
new_rot_start:	
	lsl r1, r4, #0x1
	add r1, r1, r4
	lsl r1, r1, #0x2
	add r2, r1, r6
	ldr r0, [r2]
	push {r2-r5}
	mov r2, #0x80
	ldr r1, .first_male_back
	lsl r2, r2, #0x4
	mov r4, #0x0

compare_loop:
	cmp r0, r1
	beq other_tag
	add r1, r1, r2
	add r4, #0x1
	cmp r4, #0x1A
	blt compare_loop
	
print_picture:	
	pop {r2-r5}
	lsl r1, r4, #0x1
	add r1, r1, r4
	lsl r1, r1, #0x2
	add r1, r1, r7
	ldr r1, [r1]
	ldrh r2, [r2, #8]
	lsr r2, r2, #0x1
	bl CopyMemory
		@swi #0xb
	ldr r1, .return_addr
	bx r1
	
other_tag:	
	cmp r4, #0xA
	blt FR_hero
	sub r4, #0xA
		
change_picture:	
	cmp r4, #0x4		
	blt all_maned
	sub r4, #0x4
	b change_picture
		
FR_hero:
	cmp r4, #0x5		
	blt all_maned
	sub r4, #0x5
	b FR_hero
		
all_maned:	
	mov r5, r0
	ldr r0, .var_4062
	bl call_var_load
	cmp r0, #0x0
	beq print_old_picture
	ldr r1, .table_addr
	lsl r3, r0, #0x5
	lsl r0, r0, #0x3
	add r0, r0, r3
	lsl r5, r4, #0x3	@r5 = frame number
	add r4, r1, r5	
	add r4, r0, r4
	ldr r3, [r4]	@ image
	cmp r3, #0x0
	beq print_old_picture
	ldr r0, [r4, #0x4]
	ldr r1, .first_pallette_slot
	mov r2, #16
	bl CopyMemory
		@swi 0xb
	mov r4, #0xc0
	add r1, r1, r4
	bl CopyMemory
		@swi 0xb
	ldr r1, .pallete_dump
	cmp r5, #0x0			@first frame
	bne Other
	bl CopyMemory
		@swi 0xB					@player first frame as normal
	add r1, r1, r4			@@trainer pal fix
	b Continue

Other:			
	add r1, r1, r4			@@player pal fix
		@swi 0xB
	bl CopyMemory
	
Continue:
	mov r0, r3
	b print_picture
	
print_old_picture:	
	mov r0, r5
	b print_picture

call_var_load:	
	ldr r1, .var_load
	bx r1
	
/*
emulate swi 0xb:	
	r0: src
	r1: dest
	r2: size (hwords)
*/
CopyMemory:
	push {r3-r7,lr}
	mov r3, r0	@src
	mov r4, r1	@dest
	mov r5, r2	@size
	mov r6, #0x0	@counter
	lsl r5, r5, #0x1
	
CopyLoop:
	ldrh r7, [r3]	@src
	strh r7, [r4]	@dest
	cmp r6, r5
	bge EndCopy
	add r3, #0x2
	add r4, #0x2
	add r6, #0x2
	b CopyLoop
EndCopy:
	pop {r3-r7,pc}
		
.align 2
.var_load:	.word 0x0806E569
.var_4062: 	.word 0x00004062		
.table_addr:	.word 0x081ab1d8
.first_pallette_slot:	.word 0x05000200
.pallete_dump: .word 0x020377f8
.first_male_back: .word 0x08xxxxxx
.return_addr:	.word 0x08007641

