	.file	"inline_functions.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.startup,"ax",@progbits
.global	main
	.type	main, @function
main:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r30,lo8(-128)
	ldi r31,0
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	std Z+5,__zero_reg__
	std Z+4,__zero_reg__
	ldi r30,lo8(-112)
	ldi r31,0
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	std Z+5,__zero_reg__
	std Z+4,__zero_reg__
	ldi r30,lo8(-96)
	ldi r31,0
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	std Z+5,__zero_reg__
	std Z+4,__zero_reg__
	ldi r25,0
	ldi r24,0
/* epilogue start */
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 7.3.0"
