TOOLCHAIN       := avr-
CC              := $(TOOLCHAIN)gcc
MCU             := atmega328pb

COMMON_FLAGS    += -mmcu=$(MCU)
COMMON_FLAGS    += -Os
CFLAGS          := $(COMMON_FLAGS) -std=c11

%.s: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -S -o $@ $<
