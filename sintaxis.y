
%{
#include <stdio.h>
#include "listaSimbolos.h"
Lista tablaSimb;
Tipo tipo;
int contCadenas=0;

void yyerror();
extern int yylex();
%}

%union{
char *lexema;
}

%token VAR CONST IF ELSE WHILE PRINT READ SEMICOLON COMMA ASSIGNOP LPAREN RPAREN LCORCH RCORCH 
%token <lexema> INTLITERAL 
%token <lexema> ID
%token <lexema> STRINGLITERAL
%left PLUSOP MINUSOP
%left MULTOP SLASH
%left UMENOS



%%
program : {tablaSimb=creaLS();} ID LPAREN RPAREN LCORCH declarations statement_list RCORCH {imprimirTablaS(); liberaTS();}
        ;
declarations : declarations VAR {tipo=VARIABLE;} identifier_list SEMICOLON
        | declarations CONST {tipo=CONSTANTE;} identifier_list SEMICOLON
        | /* landa-regla*/
        ;
identifier_list : identifier
        | identifier_list COMMA identifier
        ;
identifier : ID {if !(perteneceTablaS($1)) meteEntrada($1,tipo)
                        else printf("Variable %s ya declarada \n",$1); }
        | ID ASSIGNOP expression {if !(perteneceTablaS($1)) meteEntrada($1,tipo)
                        else printf("Variable %s ya declarada \n",$1); }
        ;
statement_list : statement_list statement
        | /*landa-regla*/
        ;
statement : ID ASSIGNOP expression SEMICOLON {if !(perteneceTablaS($1))
                                                        printf("Variable %s no declarada \n",$1);
                                              else if (esConstante($1))          
                                                        printf("Asignación a constante \n");}
        | LCORCH statement_list RCORCH
        | IF LPAREN expression RPAREN statement ELSE statement
        | IF LPAREN expression RPAREN statement
        | WHILE LPAREN expression RPAREN statement
        | PRINT LPAREN print_list RPAREN SEMICOLON
        | READ LPAREN read_list RPAREN SEMICOLON
        ;
print_list : print_item
        | print_list COMMA print_item
        ;
print_item : expression
        | STRINGLITERAL {meteEntrada($1,CADENA);contCadenas++;}
        ;
read_list : ID {if !(perteneceTablaS($1))
                                                        printf("Variable %s no declarada \n",$1);
                                              else if (esConstante($1))          
                                                        printf("Asignación a constante \n");}
        | read_list COMMA ID {if !(perteneceTablaS($3))
                                                        printf("Variable %s no declarada \n",$3);
                                              else if (esConstante($3))          
                                                        printf("Asignación a constante \n");}
        ;
expression : expression PLUSOP expression
        | expression MINUSOP expression
        | expression MULTOP expression
        | expression SLASH expression
        | MINUSOP expression %prec UMENOS
        | LPAREN expression RPAREN
        | ID {if !(perteneceTablaS($1))
                 printf("Variable %s no declarada \n",$1);}
        | INTLITERAL
        ;

%%
void yyerror()
{
printf("Se ha producido un error en esta expresion\n");
}

bool perteneceTablaS(char* nombre){
        PosicionLista pos = buscaLS(tablaSimb,nombre);
        PosicionLista posfin = finalLS(tablaSimb);
        if (pos==posfin){
                return false;
        } else {
                return true;
        }
}
void meteEntrada(char *nombre, Tipo tipo){
        Simbolo simb;
        simb.nombre = nombre;
        simb.tipo = tipo;
        if (tipo==CADENA){
                simb.valor = contCadenas;
        }
        insertaLS(tablaSimb,finalLS(),simb);
}
bool esConstante(char *nombre){
        PosicionLista pos = buscaLS(tablaSimb,nombre);
        Simbolo simb = recuperaLS(tablaSimb,pos);
        if(simb.tipo == CONSTANTE){
                return true; 
        } 
        else {
                return false;
        }
}
void imprimirTablaS(){
        // Lo recorro dos veces para que primero se printeen las cadenas en su formato
        // y después se printeen constantes y variables
        printf("##################\n# Seccion de datos\n\t.data\n\n");
        // Cadenas
        PosicionLista pos = inicioLS(tablaSimb);
        while(pos!=finalLS(tablaSimb)){
                Simbolo simb = recuperaLS(tablaSimb,pos);
                if (simb.tipo == CADENA){
                        printf("$str%i:\n\t.asciiz \"%s\"\n",simb.valor,simb.nombre);
                }
                pos = siguienteLS(tablaSimb,pos);
        }
        // Constantes y variables
        PosicionLista pos = inicioLS(tablaSimb);
        while(pos!=finalLS(tablaSimb)){
                Simbolo simb = recuperaLS(tablaSimb,pos);
                if (simb.tipo != CADENA){
                        printf("_%s:\n\t.word 0\n",simb.nombre);
                }
                pos = siguienteLS(tablaSimb,pos);
        }
}


