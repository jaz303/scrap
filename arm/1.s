        .text
_start:                         @ Label
        mov r0, #5              @ Load register r0 with value 5
        mov r1, #4              @ Load register r1 with value 4
        add r2, r1, r0          @ Add r0 and r1 and store in r2
stop:   b stop                  @ Infinite loop
