		.text
_start:
		mov r0, #0x11
		lsl r1, r0, #1
		lsl r2, r1, #1

stop: 	b stop
