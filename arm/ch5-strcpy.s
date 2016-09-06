.section .text

.equ SRAM_BASE, 0xA0000000

_start:
				ldr r0, =srcstr
				ldr r1, =SRAM_BASE

strcpy:
				ldrb r2, [r0], #1
				strb r2, [r1], #1
				cmp r2, #0
				bne strcpy

stop:			b stop

srcstr:
.asciz "This is my (source) string"
