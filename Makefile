
all:
	make clean
	make compile
	make image
	make run



compile:
	nasm -f elf32 -g boot.s -o boot.o
	gcc -m32 -g -fno-stack-protector -fno-builtin -c kernel.c -o kernel.o
	ld -m elf_i386 -T linker.ld -o kernel boot.o kernel.o
	mv kernel zaytun/boot/kernel


clean:
	rm boot.o
	rm kernel.o
	rm disk/Zaytun.iso


image:
	grub-mkrescue  -o disk/Zaytun.iso zaytun/

run:
	qemu-system-i386 disk/Zaytun.iso

debug:
	qemu-system-i386 disk/Zaytun.iso -s -S

