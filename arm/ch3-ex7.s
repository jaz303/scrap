.section .text

_start:
            ldr r12, =0x100

            # method 1: load immediate
            # mov r12, #0x00

            # method 2: xor with self
            eor r12, r12, r12

stop:       b stop
