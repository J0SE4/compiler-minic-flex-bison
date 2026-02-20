%{
#include "sintaxis.tab.h"
#include <stdio.h>
#define MAX_INT 2147483647
void error_lexico(int op, int l, char palabra[]);
%}
%option yylineno
digito              [0-9]
letra               [a-zA-Z]
entero              {digito}+
%%
[ \n\t]+                            ;
"/*"                                { char c; while((c = input()) != EOF && c != '*'); if(c != EOF) unput(c); }
"/*"(.|\n)*"*/"                     { /* Ignora los comentarios multilínea */ }
"//"(.)*"\n"                        { /* Ignora los comentarios de una sola línea */ }
var                                 return VAR;
const                               return CONST;
if                                  return IF;
else                                return ELSE;
while                               return WHILE;
print                               return PRINT;
read                                return READ;
({letra}|_)({digito}|_|{letra})*    {if(yyleng>32){error_lexico(2,yylineno,yytext);}
                                    yylval.lexema=strdup(yytext);return ID;}
{entero}                            {if(atoll(yytext)>MAX_INT){error_lexico(1, yylineno, yytext);}
                                    yylval.lexema=strdup(yytext);return INTLITERAL;}
";"                                 return SEMICOLON;
","                                 return COMMA;
"+"                                 return PLUSOP;
"-"                                 return MINUSOP;
"*"                                 return MULTOP;
"/"                                 return SLASH;
"="                                 return ASSIGNOP;
"("                                 return LPAREN;		
")"                                 return RPAREN;
"{"                                 return LCORCH;
"}"                                 return RCORCH; 
\"([^\"\\]|\\.)*\"                  {yylval.lexema=strdup(yytext); return STRINGLITERAL;}
[^ \n\r\ta-zA-Z0-9;,+\-*/=(){}]+    error_lexico(3, yylineno, yytext);
%%
void error_lexico(int op, int l, char palabra[]) {
    switch (op) {
        case 1:
            fprintf(stderr, "El número %s que has introducido en la línea %d es inválido.\n", palabra, l);
            break;
        case 2: 
            fprintf(stderr, "El identificador %s que has introducido en la línea %d es inválido.\n", palabra, l);
            break;
        case 3: 
            fprintf(stderr, "El caracter %s que has introducido en la línea %d es inválido.\n", palabra, l);
            break;
    }
}

