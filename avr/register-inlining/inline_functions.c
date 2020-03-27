#include <avr/io.h>

struct timer {
	uint8_t 	cra;
	uint8_t 	crb;
	uint8_t 	crc;
	uint8_t 	__padding_1;
	uint16_t	cnt;
	uint16_t	icr;
	uint16_t	ocra;
	uint16_t	ocrb;
};

struct timer *t1 = (struct timer*)(0x80);
struct timer *t2 = (struct timer*)(0x90);
struct timer *t3 = (struct timer*)(0xA0);

static void setup_timer(struct timer *t) {
	t->cra = 0;
	t->crb = 0;
	t->cnt = 0;
	// t->imsk = (1 << 1);
}

int main() {
	setup_timer(t1);
	setup_timer(t2);
	setup_timer(t3);
}
