# Worksheet 1: An Echo of Assembler

This documentation covers all tasks of Worksheet 1, demonstrating the understanding of basic x86 assembler programming, C/Assembler interface, control flow translation, and build automation using Makefiles. All source files are located in the src/ directory.

## Task 1: Basic Assembler Programming 

Task 1 focused on setting up the environment and demonstrating core assembler operations: data definition, register manipulation, and using the external I/O functions provided in asm_io.asm. All programs are linked with the standard C driver (driver.c).

### Program Implementation:  Global Variable Addition (task1.asm)

***Goal:*** Load two pre-defined 32-bit integers from the global memory (.data section), calculate their sum, and output the result using print_int.

This implementation utilizes the EAX and EBX registers. EAX serves as the primary accumulator and holds the result before the print_int call, as is standard convention.
```assembly
section .data
    ; Define two 32-bit (dd) constants
    a   dd  25
    b   dd  17

section .text
asm_main:
    enter 0,0           
    
    ; Load the value of 'a' into EAX
    mov eax, [a]        ; EAX = 25
    ; Load the value of 'b' into EBX
    mov ebx, [b]        ; EBX = 17
    
    ; Perform Addition (EAX = EAX + EBX)
    add eax, ebx        ; EAX = 42
    
    ; Output the integer stored in EAX
    call print_int      
    
    mov eax, 0          ; Set return status to 0 (Success)
    leave               
    ret                 
```

**Key Concept:** Data movement from memory to a register uses square brackets (mov eax, [a]). Arithmetic operations, like add, must operate directly on registers or between a register and a memory location.

### Program Implementation: Input, Calculation, and Output (task1.2.asm)

**Goal:** Prompt the user for a number, read the input using read_int, perform a simple manipulation (e.g., multiplication or doubling), and display the final calculated result.

This program demonstrates the use of two distinct I/O routines: print_string and read_int/print_int.
```assembly
section .data
    prompt_str  db  "Enter an integer: ", 0
    output_msg  db  "The calculated result is: ", 0

section .text
asm_main:
    enter 0,0

    ; Output the string prompt (EAX holds the address)
    mov eax, prompt_str  
    call print_string    
    
    ; Read input (Input value automatically stored in EAX)
    call read_int       
    
    ; Perform manipulation (e.g., Multiply by 5)
    mov ebx, 5          ; Multiplier
    imul ebx            ; EAX = EAX * EBX 
    
    ; Output the result message
    mov eax, output_msg
    call print_string
    
    ; Output the integer result (EAX still holds the final value)
    mov eax, [EAX holds the result]
    call print_int      

    mov eax, 0
    leave
    ret
```

***Key Concept:***  When calling I/O routines in this environment, print_string requires the address of the string in EAX, while print_int and read_int operate on the value in EAX.

## Task 2: Loops, Conditionals, and Arrays 

Task 2 involved translating typical high-level control flow structures into the primitive conditional jump (jxx) and unconditional jump (jmp) instructions of assembler.

### Name and Conditional Loop Program (loops.asm)

***Goal:***  Accept a name and a count. Validate the count using an if-else structure (Count must be $> 50$ AND $< 100$). If valid, print the welcome message in a loop; otherwise, print an error.

The validation uses multiple CMP (Compare) instructions to set processor flags, followed by conditional jumps to implement the required boolean logic.
```assembly
; Read count into EBX

; Check 1: Is EBX > 50?
mov ecx, 50
cmp ebx, ecx
jle  error_path      ; Jump if Less than or Equal to 50 (Failure)

; Check 2: Is EBX < 100?
mov ecx, 100
cmp ebx, ecx
jge  error_path      ; Jump if Greater than or Equal to 100 (Failure)

; Success Path:
mov ecx, ebx         ; Use EBX (the valid count) as the loop counter
call print_welcome   ; Call routine to print name once
jmp start_loop

start_loop:
    ; ... print the welcome message again ...
loop start_loop      ; Decrements ECX and jumps if ECX != 0

jmp end_program

error_path:
    ; ... print error message ...
end_program:
    ; ... return 0 ...
```

***Key Concept:*** The cmp instruction is equivalent to subtraction without storing the result, only updating the status flags. Jumps like jle and jge inspect these flags to determine the next instruction address.

### Array Summation Program (array_sum.asm)

**Goal:** Initialize an array of 100 elements with values 1 through 100. Sum all the elements and display the final total.

Iterating over the array requires using a register as a pointer (ESI) and ensuring the pointer is incremented correctly (by 4 bytes for 32-bit integers).
```assembly
section .bss
    array_data  resd    100   ; Reserve 100 32-bit integers

section .text
asm_main:
    ; ... setup ...
    mov ecx, 100             ; Initialize counter
    mov esi, array_data      ; ESI points to array start
    mov ebx, 0               ; EBX holds the running sum

sum_loop:
    mov eax, [esi]           ; Load the current array element into EAX
    add ebx, eax             ; Add the element to the running sum in EBX
    add esi, 4               ; Move pointer to the next element (4 bytes)
    loop sum_loop            ; Decrement ECX, jump if not zero
    
    ; Output the final sum stored in EBX
    mov eax, ebx
    call print_int
    ; ...
```

***Key Concept:**  The loop instruction simplifies iteration by combining DEC ECX and JNE (Jump if Not Equal) to zero. Array element access uses the pointer register in brackets: [esi].

### Range Summation Program (range_sum.asm)
**Goal:** Read a start and end range from the user. Validate that the range is within $[1, 100]$ and that $Start \le End$. If valid, calculate the sum of the integers in that range.
This code demonstrates comprehensive input validation before proceeding to the summation loop.
```assembly
; Read start into EAX, read end into EBX

; Check 1: Start <= End?
cmp eax, ebx
jg  invalid_range_msg   ; Jump if Start > End

; Check 2: Start >= 1 AND End <= 100 (Simplified check)
mov ecx, 1
cmp eax, ecx
jl  invalid_range_msg   ; Jump if Start < 1

mov ecx, 100
cmp ebx, ecx
jg  invalid_range_msg   ; Jump if End > 100

; If all checks pass, execution continues here:
jmp  summation_logic

invalid_range_msg:
    ; ... print error ...
    jmp end_program

summation_logic:
    ; EBX (End) is the counter limit. EAX (Start) is the initial value.
    ; Calculate the loop count: ECX = EBX - EAX + 1
    mov ecx, ebx
    sub ecx, eax
    inc ecx
    
    ; ... custom loop to sum numbers from EAX to EBX using ECX as count ...
```
***Key Concept:*** Complex conditions are handled by using multiple sequential comparisons and immediately jumping to an error handler upon the first failure. If execution falls through all conditional jumps, the input is valid.

## Task 3: Creating a Makefile 

The Makefile is used to automate the multi-step process of assembling (nasm), compiling (gcc -c), and linking (gcc -m32) all the object files into final executables.

Makefile Content
```make
# The 'all' rule is the default target, building all required executables.
all: task1 task1_2 array_sum loops range_sum

task1: src/driver.o src/task1.o src/asm_io.o
	gcc -m32 src/driver.o src/task1.o src/asm_io.o -o task1

task1_2: src/driver.o src/task1_2.o src/asm_io.o
	gcc -m32 src/driver.o src/task1_2.o src/asm_io.o -o task1_2

loops: src/driver.o src/loops.o src/asm_io.o
	gcc -m32 src/driver.o src/loops.o src/asm_io.o -o loops

array_sum: src/driver.o src/array_sum.o src/asm_io.o
	gcc -m32 src/driver.o src/array_Sum.o src/asm_io.o -o array_sum

range_sum: src/driver.o src/range_sum.o src/asm_io.o
	gcc -m32 src/driver.o src/range_sum.o src/asm_io.o -o range_sum

src/driver.o: src/driver.c
	gcc -m32 -c src/driver.c -o src/driver.o

src/asm_io.o: src/asm_io.asm
	nasm -f elf src/asm_io.asm -o src/asm_io.o

src/task1.o: src/task1.asm
	nasm -f elf src/task1.asm -o src/task1.o

src/task1_2.o: src/task1_2.asm
	nasm -f elf src/task1_2.asm -o src/task1_2.o

src/loops.o: src/loops.asm
	nasm -f elf src/loops.asm -o src/loops.o

src/array_sum.o: src/array_sum.asm
	nasm -f elf src/array_sum.asm -o src/array_sum.o

src/range_Sum.o: src/range_sum.asm
	nasm -f elf src/range_sum.asm -o src/range_sum.o

# Clean rule to remove all generated executables and object files
clean:
	rm -f task1 task1_2 loops array_sum range_sum
	rm -f src/*.o
```

### Explanation of Makefile Structure

Targets & Dependencies: Each executable (e.g., task1) is a target and depends on its required object files (driver.o, task1.o, asm_io.o), which are its prerequisites.

Recipes: The line indented with a TAB (\t) is the recipe (the command to run). For .asm files, the recipe is nasm; for the final executable and the C file, the recipe is gcc -m32.

Efficiency: Running make only executes the recipe if the target is missing or if any of its prerequisites have been modified since the last build.
