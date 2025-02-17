/* AT&T Syntax Version of boot.s */

/* Define 32-bit mode */
.code32

/* .text section: Read-only and executable */
.section .text
    .align 4                          /* Align on 4-byte boundary */
    .long 0x1BADB002                  /* Magic value for GRUB */
    .long 0x00000000                  /* Flags (all zeros) */
    .long -(0x1BADB002 + 0x00000000)  /* Checksum (negation of sum) */

.globl _start                          /* Declare 'start' as global */
.extern kmain                         /* Reference external function 'kmain' */

_start:
    cli                               /* Disable CPU interrupts */
    movl $stack_space, %esp           /* Initialize stack pointer */
    call kmain                        /* Call the external function 'kmain' */
    hlt                               /* Halt the CPU */

HaltKernel:
    cli                               /* Disable interrupts again */
    hlt                               /* Halt the CPU */
    jmp HaltKernel                    /* Infinite loop to halt */

/* .bss section: Read/write, non-executable */
.section .bss
    .space 8192                       /* Reserve 8192 bytes for the stack */
stack_space:                          /* Label for stack space */
