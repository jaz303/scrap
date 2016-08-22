.section .text

_start:
			mov r6, #0x04
			movs r6, r6, lsl #5

stop: 		b stop
