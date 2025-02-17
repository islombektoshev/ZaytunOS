
# all:
# 	make clean
# 	make compile
# 	make image
# 	make run

all:
	make compile-zig
	make image-zig
	make run


compile:
	nasm -f elf32 -g boot.s -o boot.o
	gcc -m32 -g -fno-stack-protector -fno-builtin -c kernel.c -o kernel.o
	gcc -m32 -g -fno-stack-protector -fno-builtin -c vga.c -o vga.o
	ld -m elf_i386 -T linker.ld -o kernel boot.o kernel.o vga.o
	mv kernel zaytun/boot/kernel


compile-zig:
	zig build

image-zig:
	mv zig-out/bin/kernel zaytun/boot/kernel
	grub-mkrescue  -o disk/Zaytun.iso zaytun/

clean:
	rm -f boot.o
	rm -f kernel.o
	rm -f vga.o
	rm -f kernel
	rm -f disk/Zaytun.iso


image:
	grub-mkrescue  -o disk/Zaytun.iso zaytun/

run:
	qemu-system-i386 disk/Zaytun.iso

debug:
	qemu-system-i386 disk/Zaytun.iso -s -S

