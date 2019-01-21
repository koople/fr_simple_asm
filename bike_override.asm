.text
.align 2
.thumb
.thumb_func
/*
Lets you use bike on any map
-old limitation is from 0x18th byte in 02036dfc struct. unsure where set originally.
this results in:
	01 20 C0 46 at 0x55ca0
	
Alternatively:
	Change 25th byte to 0x1 in advanced header (ctrl+h) in Map Options on the map you want to use bike on
		(first of last four bytes)
*/

.org 0x55ca0
	mov r0, #0x1
	
