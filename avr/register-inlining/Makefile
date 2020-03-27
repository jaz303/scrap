TOOLCHAIN       := avr-
CC              := $(TOOLCHAIN)gcc
MCU             := atmega328pb

COMMON_FLAGS    += -mmcu=$(MCU)
COMMON_FLAGS    += -Os
CFLAGS          := $(COMMON_FLAGS) -std=c11

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<
