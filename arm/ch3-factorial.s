		.text
_start:	
		mov 	r6, #10
		mov 	r7, #1
loop:	cmp 	r6, #0
		mulgt	r7, r6, r7
		subgt 	r6, r6, #1
		bgt		loop
stop: 	b 		stop
