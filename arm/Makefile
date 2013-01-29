%.o: %.s
	arm-none-eabi-as -o $@ $<

%.elf: %.o
	arm-none-eabi-ld -Ttext=0x0 -o $@ $<

%.tbin: %.elf
	arm-none-eabi-objcopy -O binary $< $@

%.bin: %.tbin
	dd if=/dev/zero of=$@ bs=4096 count=4096
	dd if=$< of=$@ bs=4096 conv=notrunc

ALL_SRC := $(wildcard *.s)
ALL_OBJ = $(ALL_SRC:.s=.o)
ALL_BIN = $(ALL_SRC:.s=.bin)

obj: $(ALL_OBJ)

all: $(ALL_BIN)

clean:
	rm -f *.{tbin,bin,elf,o}