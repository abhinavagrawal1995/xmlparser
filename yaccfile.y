%{
#include <string.h>
#include <stdio.h>
#include <iostream>
using namespace std;
extern FILE *yyin;
char *abc,*list[50];
int c=0,t=0;
void yyerror(char *msg);
int yylex();
%}
%union {char *s;}
%token VERSION ATTDEF ENDDEF EQ SLASH CLOSE END
%token <s> ENCODING NAME VALUE DATA COMMENT START
%type <s> name_opt

%%
document
 : prolog element misc_seq_opt
 ;
prolog
 : version_opt encoding_opt
   misc_seq_opt
 ;
version_opt
 : VERSION			{printf("<?XML-VERSION 1.0?>\n");}
 
 ;
encoding_opt
 : ENCODING			{printf("<?XML-ENCODING %s\n",$1); free($1);}
 | /*empty*/
 ;
misc_seq_opt
 : misc_seq_opt misc
 | /*empty*/
 ;
misc
 : COMMENT			{printf("%s", $1);}
 | attribute_decl
 ;
attribute_decl
 : ATTDEF NAME			{printf("\n<?XML-ATT %s", $2);}
   attribute_seq_opt ENDDEF	{printf("?>\n");}
 ;	
element
 : START				{printf("\n<%s", $1); list[c++]=abc; t++; free($1);}
   attribute_seq_opt
   empty_or_content
 ;

empty_or_content
 : SLASH CLOSE			{printf("/>\n");}
 | CLOSE			{printf(">\n");}
   content END name_opt CLOSE	{
   									printf("\n</%s>\n", $5);abc=$5;
   									if(strcmp(abc,list[t-1])!=0) 
   									{	printf("\n\nERROR : '%s' Opened but '%s' closed. Terminated.\n\n",list[t-1],abc);
   										exit(0);
   									}
   									else
   										t--;
   								}
 ;
content
 : content DATA			{printf("%s", $2); free($2);}
 | content misc
 | content element
 | /*empty*/
 ;
name_opt
 : NAME				{$$ = $1;}
 | /*empty*/			{$$ = strdup("");}
 ;
attribute_seq_opt
 : attribute_seq_opt attribute
 | /*empty*/
 ;
attribute
 : NAME				{printf(" %s", $1); free($1);}
 | NAME EQ VALUE		{printf(" %s=%s", $1, $3); free($1); free($3);}
 ;
%%

int yywrap(void)
{
  return 1;
}

void yyerror(char *msg)
{
  //fprintf(stderr, "%s\n", msg);
  printf("\n\n%s\n\n",msg);
}

int main(int argc, char *argv[])
{
	char *s;
	int no_errors = 0, no_error2 = 0, no_errors3 = 0,i;
	yyin = fopen("input.xml", "r");
		
	int x = yyparse();
	cout << "total number of errors is " << x << endl;
	printf("\n**Metadata (%d)** \n",c);
	for(i=0;i<c;i++)
		printf("%s\n",list[i]);
	//lexerr(s);
	//cout << "\n************************************************************\n";
	//yaccers(s);	
	return 0;
}
