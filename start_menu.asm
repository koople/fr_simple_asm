.text
.align 2
.thumb
.thumb_func
.global start_menu
/*
insert 00 48 00 47 (xx+1) xx xx 08 at 6ed5c

*/

.equ offset, 0x08xxxxxx		@ insert location

.equ DEX_FLAG, 0x250
.equ POKE_FLAG, 0x251
.equ BAG_FLAG, 0x252
.equ PLAYER_FLAG, 0x253
.equ SAVE_FLAG, 0x254
.equ OPT_FLAG, 0x255
.equ EXIT_FLAG, 0x256

Main:
	bl check_safari_zone
	cmp r0, #0x1
	bne regular_menu
	ldr r0, =(0x0806ed86 +1)
	bx r0
	
regular_menu:
	push {r4-r5}
	mov r1, #0x0
	ldr r4, =(offset+table)
	
loop:
	lsl r0, r1, #0x2
	add r0, r0, r4
	mov r5, r0

	cmp r1, #0x6
	beq add_option	@ auto-add exit	
	
	ldrh r0, [r5]	@ flag to check
	push {r1}
	bl check_flag
	pop {r1}
	cmp r0, #0x1
	bne loop_incr
	
add_option:
	ldrb r0, [r5, #0x2]		@ menu index
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	push {r1}
	bl add_opt
	pop {r1}
	
loop_incr:
	cmp r1, #0x6	@ num opts
	beq exit
	add r1, #0x1
	b loop
	
exit:
	pop {r4-r5}
	pop {r0}
	bx r0
	
.align 2
table:
.hword DEX_FLAG
.byte 0
.byte 0
.hword POKE_FLAG
.byte 1
.byte 0
.hword BAG_FLAG
.byte 2
.byte 0
.hword PLAYER_FLAG
.byte 3
.byte 0
.hword SAVE_FLAG
.byte 4
.byte 0
.hword OPT_FLAG
.byte 5
.byte 0
.hword EXIT_FLAG
.byte 6
.byte 0
	
	
check_flag:
	ldr r2, =(0x0806e6d0 +1)
	bx r2
	
add_opt:
	ldr r2, =(0x0806ed94 +1)
	bx r2

check_safari_zone:
	ldr r0, =(0x080a0e90 +1)
	bx r0
	