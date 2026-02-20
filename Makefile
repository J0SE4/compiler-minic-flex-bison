sintaxis: main.c sintaxis.tab.c lex.yy.c sintaxis.tab.h
	gcc lex.yy.c main.c sintaxis.tab.c -lfl -o sintaxis
sintaxis.tab.c sintaxis.tab.h: sintaxis.y 
	bison -d -v sintaxis.y
lex.yy.c: lexico.l
	flex lexico.l
clear:
	rm lex.yy.c sintaxis.tab.c sintaxis.tab.h sintaxis
run: 
	./sintaxis p