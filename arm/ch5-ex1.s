.section .text

_start:
			ldr r0, =val
			ldrsb r13, [r0]
			ldrsh r12, [r0]
			ldr r11, [r0]
			ldrb r10, [r0]

stop: 		b stop

.balign 4
val:
.byte 0x06, 0xFC, 0x03, 0xFF