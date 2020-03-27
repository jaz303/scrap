	.file	"macros.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
.global	setup_timers
	.type	setup_timers, @function
setup_timers:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts 128,__zero_reg__
	sts 129,__zero_reg__
	sts 160,__zero_reg__
	sts 161,__zero_reg__
	sts 144,__zero_reg__
	sts 145,__zero_reg__
/* epilogue start */
	ret
	.size	setup_timers, .-setup_timers
	.ident	"GCC: (GNU) 7.3.0"
