# Makefile for UFCFWK-15-2 Worksheet 1

# The 'all' rule is the default target, building all required executables.
all: task1 task1_2 loops array_sum range_sum

# ----------------------------------------------------------------------
# EXECUTABLE TARGETS (Linking using gcc -m32)
# ----------------------------------------------------------------------

task1: src/driver.o src/task1.o src/asm_io.o
	gcc -m32 src/driver.o src/task1.o src/asm_io.o -o task1

task1_2: src/driver.o src/task1_2.o src/asm_io.o
	gcc -m32 src/driver.o src/task1_2.o src/asm_io.o -o task1_2

loops: src/driver.o src/loops.o src/asm_io.o
	gcc -m32 src/driver.o src/loops.o src/asm_io.o -o loops

array_sum: src/driver.o src/array_sum.o src/asm_io.o
	gcc -m32 src/driver.o src/array_sum.o src/asm_io.o -o array_sum

range_sum: src/driver.o src/range_sum.o src/asm_io.o
	gcc -m32 src/driver.o src/range_sum.o src/asm_io.o -o range_sum

# ----------------------------------------------------------------------
# OBJECT FILE TARGETS (Assembly/Compilation)
# These rules create the intermediate .o files required for linking.
# ----------------------------------------------------------------------

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

src/range_sum.o: src/range_sum.asm
	nasm -f elf src/range_sum.asm -o src/range_sum.o

# Clean rule to remove all generated executables and object files
clean:
	rm -f task1 task1_2 loops array_sum range_sum
	rm -f src/*.o

