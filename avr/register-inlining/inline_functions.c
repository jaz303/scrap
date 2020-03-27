#include <avr/io.h>

struct timer {
	volatile uint8_t 	cra;
	volatile uint8_t 	crb;
	volatile uint8_t 	crc;
	volatile uint8_t 	__padding_1;
	volatile uint16_t	cnt;
	volatile uint16_t	icr;
	volatile uint16_t	ocra;
	volatile uint16_t	ocrb;
} __attribute__((packed));

#define T1 ((struct timer*)(0x80))
#define T2 ((struct timer*)(0x90))
#define T3 ((struct timer*)(0xA0))

static void setup_timer(struct timer *t) {
	t->cra = 0;
	t->crb = 0;
	t->cnt = 0;
	// t->imsk = (1 << 1);
}

int main() {
	setup_timer(T1);
	setup_timer(T2);
	setup_timer(T3);
}
