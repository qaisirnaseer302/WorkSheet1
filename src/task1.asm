; task1.asm (32-bit Windows NASM)
%include "asm_io.inc"

SECTION .data
    a dd 5
    b dd 7

section .bss
	result resd 1
SECTION .text
	global asm_main
	extern print_int

asm_main:
    enter 0,0
    mov eax, [a]
    add eax, [b]
    add eax,ebx
    mov [result],eax
    call print_int
    mov eax,0
    leave
    ret

