input = input.txt
output = output.txt

main: cal.tab.c lex.yy.c
	bison -d cal.y
	flex cal.l
	# cal.tab.c এর বদলে y.tab.c ব্যবহার করুন
	gcc y.tab.c lex.yy.c -o calc.exe


# Run target
run: calc.exe
	./calc.exe < $(input) > $(output)


clean:
	rm -f y.tab.c y.tab.h lex.yy.c calc.exe $(output)

.PHONY: main clean run