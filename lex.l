%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"
void showError();
%}

numbers ([0-9])+
ids     ([a-zA-Z]+[0-9]*)+

%%
inicio    {return INICIO;}
fin       {return FIN;}

escribir  {return ESCRIBIR;}
leer      {return LEER;}
"("       {return PARENTESIS_ABRE;}
")"       {return PARENTESIS_CIERRA;}
","       {return COMA;}
":="      {return ASIGNACION;}

"+"       {return SUMA;}
"-"       {return RESTA;}

{numbers} {yylval.numeros = atoi(yytext); return NUMEROS;}
{ids}     {yylval.cadena = yytext; return ID;}
;         {return PUNTOYCOMA;}

[ \t\r]   {}

.         {showError();}

%%

void showError(char* other) {
    printf("\n¡¡¡error lexico: %s!!!\n", other);
}

int yywrap(void) {
    return 1;
}