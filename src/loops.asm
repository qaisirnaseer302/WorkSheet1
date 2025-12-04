; print_n.asm - Print name N times if 50 < N < 100
%include "asm_io.inc"

SECTION .data
    prompt_name  db "Enter your name: ",0
    prompt_num   db "Enter a number (51-99): ",0
    invalid_msg  db "Invalid! Number must be > 50 and < 100",0
    newline      db 10,0

SECTION .bss
    name resb 32   ; buffer for name

SECTION .text
global asm_main
extern print_string, read_int, print_int, read_char, print_char, print_nl

asm_main:
    ; ask for name
    mov eax, prompt_name
    call print_string
    mov eax, name
    call read_char          ; read first char
read_loop:
    cmp eax, 10             ; newline?
    je read_done
    mov [eax], al
    add eax, 1
    call read_char
    jmp read_loop
read_done:
    mov byte [eax], 0       ; end name with null

    ; ask for number
    mov eax, prompt_num
    call print_string
    call read_int           ; input → EAX
    mov ebx, eax            ; EBX = N

    ; validation: if N<=50 or N>=100 → invalid
    cmp ebx, 51
    jl invalid
    cmp ebx, 99
    jg invalid

    ; valid → print name N times
print_loop:
    mov eax, name
    call print_string
    call print_nl
    dec ebx
    jnz print_loop
    jmp done

invalid:
    mov eax, invalid_msg
    call print_string
    call print_nl

done:
    xor eax, eax
    ret

