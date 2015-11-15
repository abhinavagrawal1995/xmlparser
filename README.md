XML-File-Error-Parsing
======================

Lex and Yacc Program to detect errors in an XML File

How to run


Step1: Compile the lex file
       flex lexfile.l
	
Step2: Compile the yacc file
       yacc -d yaccfile.y

Step3: g++ y.tab.c lex.yy.c -lfl

Step4 : ./a.out input.xml
	     
Step5: Output: Errors.
	     


