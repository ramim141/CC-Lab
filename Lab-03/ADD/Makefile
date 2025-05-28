all:
	gcc ID.c -o ID -std=c99
	gcc -E ID.c > ID.i
	gcc -S -masm=intel ID.i
	gcc -c ID.s -o ID.o
	objdump -M intel -d ID.o > ID.dump