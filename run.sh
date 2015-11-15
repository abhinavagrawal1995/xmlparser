lex lexfile.l
yacc -d yaccfile.y
g++ y.tab.c lex.yy.c -lfl
