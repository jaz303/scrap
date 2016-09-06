.section .text

_start:
				ldr r0, =input
				ldr r1, =end
				mov r3, #0
loop:
				cmp r0, r1
				beq stop
				ldr r2, [r0], #4
				add r3, r3, r2
				b loop

stop:
				b stop

.balign 4
input:

.word 0xFEBBAAAA, 0x12340000, 0x88881111
.word 0x00000013, 0x80808080, 0xFFFF0000

end:

.word 0x00000000
