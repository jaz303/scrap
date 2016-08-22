.section .text

_start:
			ldr r3, =0x05

			mul r2, r3, r3
			mov r0, #6
			mul r2, r2, r0

			mov r0, #9
			mul r1, r3, r0

			sub r2, r2, r1

			mov r0, #2
			add r2, r2, r0

stop: 		b stop
