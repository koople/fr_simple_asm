.text
.align 2
.thumb
.thumb_func
.global ExpandBuffers
/*
replace FD 07-0D to load from custom RAM instead of loading default useless strings

replace ALL pointers (+1) starting at 231e8c

Script Func Pointer Changes to above table:
	bufferpokemon:			6bcc0
	bufferfirstpokemon:		6bd08
	bufferpartypokemon:		6bd54
	bufferitem:				6bd8c
	bufferattack:			6be88
	buffernumber: 			6bed0
	bufferstd:				6bf0c
	bufferstring:			6bf38
		
*/


.equ Offset, 0xYYYYYY	@ where function will be inserted into ROM
.equ Set1, 0x02xxxxxx	@ first block of RAM, 3 sets of 4 bytes each (12 bytes)
.equ Set2, 0x02xxxxxx	@ second block of RAM, 4 sets of 16 bytes each (64 bytes)

.equ ROM, 0x08000000




.org 0x6bcc0			@ bufferpokemon
.word RAMTable+ROM

.org 0x6bd08			@ bufferfirstpokemon
.word RAMTable+ROM

.org 0x6bd54			@ bufferpartypokemon
.word RAMTable+ROM

.org 0x6bd8c			@ bufferitem
.word RAMTable+ROM

.org 0x6be88			@ bufferattack
.word RAMTable+ROM

.org 0x6bed0			@ buffernumber
.word RAMTable+ROM

.org 0x6bf0c			@ bufferstd
.word RAMTable+ROM

.org 0x6bf38			@ bufferstring
.word RAMTable+ROM


.org 0x231e8c
.word Offset+1+ROM
.word Start08+1+ROM
.word Start09+1+ROM
.word Start0A+1+ROM
.word Start0B+1+ROM
.word Start0C+1+ROM
.word Start0D+1+ROM

.org Offset
Start07:
	ldr r0, =(Set1)	@4 byte buffer
	b Return
	
Start08:
	ldr r0, =(Set1 +4)	@4byte buffer
	b Return

Start09:
	ldr r0, =(Set1 +8)	@4byte buffer
	b Return
	
Start0A:
	ldr r0, =(Set2)	@16 byte buffer
	b Return
	
Start0B:
	ldr r0, =(Set2 +16)	@16byte buffer
	b Return
	
Start0C:
	ldr r0, =(Set2 +32)	@16byte buffer
	b Return
	
Start0D:
	ldr r0, =(Set2 +48)	@16 byte buffer

Return:
	bx lr
	
RAMTable:
.word 0x02021cd0	@FD 02 = buffer0
.word 0x02021cf0	@FD 03 = buffer1
.word 0x02021d04	@FD 04 = buffer2
.word 0x00000000	@FD 05 = buffer3 	(reserved for player name)
.word 0x00000000	@FD 06 = buffer4 	(reserved for rival name)
.word Set1			@FD 07 = buffer5
.word Set1+4		@FD 08 = buffer6
.word Set1+8		@FD 09 = buffer7
.word Set2			@FD 0A = buffer8
.word Set2+16		@FD 0B = buffer9
.word Set2+32		@FD 0C = buffer10
.word Set2+48		@FD 0D = buffer11

.align 2
