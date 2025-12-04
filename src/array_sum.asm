; array_sum.asm - Sum numbers 1..100 using loop
%include "asm_io.inc"

SECTION .data
    result_msg db "Sum of numbers 1 to 100 is: ",0

SECTION .text
global asm_main
extern print_string, print_int, print_nl

asm_main:
    mov ecx, 1     ; counter
    mov ebx, 0     ; sum

loop_start:
    add ebx, ecx
    inc ecx
    cmp ecx, 101
    jle loop_start

    ; print result
    mov eax, result_msg
    call print_string
    mov eax, ebx
    call print_int
    call print_nl

    xor eax, eax
    ret

