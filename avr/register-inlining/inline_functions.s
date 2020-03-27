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
	lds r30,t1
	lds r31,t1+1
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	std Z+5,__zero_reg__
	std Z+4,__zero_reg__
	lds r30,t2
	lds r31,t2+1
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	std Z+5,__zero_reg__
	std Z+4,__zero_reg__
	lds r30,t3
	lds r31,t3+1
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	std Z+5,__zero_reg__
	std Z+4,__zero_reg__
	ldi r25,0
	ldi r24,0
/* epilogue start */
	ret
	.size	main, .-main
.global	t3
	.data
	.type	t3, @object
	.size	t3, 2
t3:
	.word	160
.global	t2
	.type	t2, @object
	.size	t2, 2
t2:
	.word	144
.global	t1
	.type	t1, @object
	.size	t1, 2
t1:
	.word	128
	.ident	"GCC: (GNU) 7.3.0"
.global __do_copy_data
