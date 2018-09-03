bhaswati:
	lex cali.l
	bison -d cali.y
	gcc lex.yy.c cali.tab.c -o a.exe
	./a.exe
