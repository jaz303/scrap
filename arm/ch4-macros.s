.macro addmul a, b, c
	add \a, \b, \c
	add \a, \a, #6
	lsl \a, \a, #3
.endm

.section .text

_start:
			mov r1, #100
			mov r2, #16
			addmul r0, r1, r2
stop: 		b stop
