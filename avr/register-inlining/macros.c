#include <avr/io.h>

#define T1 TCCR1A, TCCR1B, TCNT1, OCR1A, TIMSK1, TIFR1
#define T2 TCCR4A, TCCR4B, TCNT4, OCR4A, TIMSK4, TIFR4
#define T3 TCCR3A, TCCR3B, TCNT3, OCR3A, TIMSK3, TIFR3

#define SETUP_TIMER(args) SETUP_TIMER_INNER(args)
#define SETUP_TIMER_INNER(ccra, ccrb, cnt, ocr, imsk, ifr) \
	ccra = 0; \
	ccrb = 0;

// #define TIMER_RESET_COUNTER(args, pulse_length) TIMER_RESET_COUNTER_INNER(args, pulse_length)
// #define TIMER_RESET_COUNTER_INNER(ccra, ccrb, cnt, ocr, imsk, ifr, pulse_length) \
// 	cnt = 0; \
// 	ocr = (pulse_length)

// #define TIMER_START(args) TIMER_START_INNER(args)
// #define TIMER_START_INNER(ccra, ccrb, cnt, ocr, imsk, ifr) \
// 	(ccrb = (ccrb & ~GATE_TIMER_PRESCALER_MASK) | GATE_TIMER_PRESCALER)

// // Stop timer, clear pending interrupt
// #define TIMER_CANCEL(args) TIMER_CANCEL_INNER(args)
// #define TIMER_CANCEL_INNER(ccra, ccrb, cnt, ocr, imsk, ifr) \
// 	(ccrb &= ~GATE_TIMER_PRESCALER_MASK); \
// 	(ifr |= (1 << 1))

void setup_timers() {
	SETUP_TIMER(T1);
	SETUP_TIMER(T2);
	SETUP_TIMER(T3);
}