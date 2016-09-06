.section .text

_start:
				mov r0, #0
				ldr r1, =array
				mov r2, #10
				mov r3, #0

zero:
				cmp r3, r2
				beq stop
				strb r0, [r1, r3]
				add r3, r3, #1
				b zero

stop:
				b stop

.balign 4
.section .data

array:
.byte 0x11, 0x22, 0x33, 0x44
.byte 0x55, 0x66, 0x77, 0x88