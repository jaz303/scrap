.section .text

_start:
            mov r7, #0x02
            mov r8, #0x04
            add r9, r7, r8, lsl #2

stop:       b stop
