input = input2.txt
output = output2.txt

main: lexer.l parser.y
	bison -d parser.y
	flex lexer.l
	gcc parser.tab.c lex.yy.c -o a
	./a <$(input) > $(output)