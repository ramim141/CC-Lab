input = input.txt
output = output.txt

main: cal.l cal.y
	bison -d cal.y
	flex cal.l
	gcc cal.tab.c lex.yy.c -o calc.exe

run:
	./calc.exe < $(input) > $(output)

clean:
	rm -f cal.tab.c cal.tab.h lex.yy.c calc.exe