.section .text

_start:
			mov r9, #0x02
			rsb r10, r9, r9, lsl #3

stop: 		b stop
