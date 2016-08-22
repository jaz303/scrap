.section .text

_start:
			# pseudo instruction, generates either
			# a mov (if constant can be represented
			# as byte plus even left shift), or an
			# ldr instruction offset by some fixed
			# amount from pc (assembler plants the
			# data in the correct position)
			ldr r0, =0x12345678
			ldr r1, =0x87654321
			eor r0, r0, r1
			eor r1, r0, r1
			eor r0, r0, r1
stop: 		b stop

