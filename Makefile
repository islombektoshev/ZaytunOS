compile: boot.o
	nasm -f elf32 boot.s -o boot.o
	x86_64-elf-gcc -m32 -fno-stack-protector -fno-builtin -c kernel.c -o kernel.o
	x86_64-elf-ld -m elf_i386 -T linker.ld -o kernel boot.o kernel.o
	mv kernel zaytun/boot/kernel


clean:
	rm boot.o
	rm kernel.o


image: compile


