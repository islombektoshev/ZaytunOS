BITS 32

section .text                       ; .text section generally read-only and executable
    ALIGN 4                         ; We want aligned properly on 32 bit system
    DD 0x1BADB002                   ; D_efine D_oubleword (4 byte) 'Magic' value for GRUB to where to start reading for operating system
    DD 0x00000000                   ; Flags just all zeros right now
    DD -(0x1BADB002 + 0x00000000)   ; Check Sum value is negation of sum of all values on above

global start                        ; Declarin Function start as global
extern kmain                        ; I need ref to external function kmain

start:
    CLI                             ; Disable CPU interrupts
    MOV esp, stack_space            ; Init Stack Pointer
    CALL kmain                      ; call kmain external function
    HLT                             ; Just halt
HaltKernel:
    CLI                             ; in case it doesn't halt
    HLT                             ; halt again
    JMP HaltKernel                  ; or halt again



section .bss                        ; for variable. read/write non executable
RESB 8192                           ; reserve some bytes stack grows backword
stack_space:                        ; stack space label

