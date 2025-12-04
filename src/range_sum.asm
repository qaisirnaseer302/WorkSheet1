; range_sum.asm - sum numbers in user-defined range
%include "asm_io.inc"

SECTION .data
    prompt_low  db "Enter low value: ",0
    prompt_high db "Enter high value: ",0
    invalid_msg db "Invalid range!",0
    result_msg  db "Sum = ",0

SECTION .text
global asm_main
extern read_int, print_string, print_int, print_nl

asm_main:
    mov eax, prompt_low
    call print_string
    call read_int
    mov ebx, eax        ; low

    mov eax, prompt_high
    call print_string
    call read_int
    mov ecx, eax        ; high

    ; validate high > low
    cmp ecx, ebx
    jle invalid

    mov edx, 0          ; sum
sum_loop:
    add edx, ebx
    inc ebx
    cmp ebx, ecx
    jle sum_loop

    mov eax, result_msg
    call print_string
    mov eax, edx
    call print_int
    call print_nl
    jmp done

invalid:
    mov eax, invalid_msg
    call print_string
    call print_nl

done:
    xor eax, eax
    ret

