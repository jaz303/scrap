.section .text

_start:
            ldr r1, =-149
            ldr r2, =-4321
            add r7, r1, r2

stop:       b stop
