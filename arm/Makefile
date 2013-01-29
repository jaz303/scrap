%.o: %.s
	arm-none-eabi-as -o $@ $<

%.elf: %.o
	arm-none-eabi-ld -Ttext=0x0 -o $@ $<

%.bin: %.elf
	dd if=/dev/zero of=$@ bs=4096 count=4096
	arm-none-eabi-objcopy -O binary $< | dd of=$@ bs=4096 conv=notrunc
	
all:
	@echo boom

clean:
	rm -f *.{bin,elf,o}