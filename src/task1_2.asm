; task1_2.asm - Read two integers and print their sum
%include "asm_io.inc"

SECTION .data
    prompt1     db "Enter first number: ",0
    prompt2     db "Enter second number: ",0
    result_msg  db "The sum is: ",0

SECTION .text
global asm_main
extern print_string, read_int, print_int, print_nl

asm_main:
    ; Ask for first number
    mov eax, prompt1
    call print_string
    call read_int            ; result → EAX
    mov ebx, eax             ; store in EBX

    ; Ask for second number
    mov eax, prompt2
    call print_string
    call read_int            ; result → EAX

    ; EAX + EBX → EAX
    add eax, ebx

    ; Print result message
    mov ebx, eax             ; keep sum stored
    mov eax, result_msg
    call print_string

    mov eax, ebx             ; restore sum into EAX
    call print_int
    call print_nl

    xor eax, eax             ; return 0
    ret

