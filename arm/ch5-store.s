.equ ram_base, 0xA0000000

.section .text

_start:
			ldr r8, =ram_base
			mov r3, #0x01
			mov r4, #0x02

			# post increment r8 by 4
			str r3, [r8], #4

			ldr r8, =ram_base

			# write effective address back to r8
			str r4, [r8, #4]!

stop: 		b stop