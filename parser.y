%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex();
int yyerror(char *s);

struct Variable {
    char *nombre;
    int valor;
};

#define MAX_VARIABLES 100
struct Variable tabla_simbolos[MAX_VARIABLES];
int num_variables = 0;

// Función para buscar una variable en la tabla de símbolos
int buscar_variable(char *nombre) {
    for (int i = 0; i < num_variables; i++) {
        if (strcmp(tabla_simbolos[i].nombre, nombre) == 0) {
            return i;
        }
    }
    return -1; // Variable no encontrada
}

char *obtenerVariable(char *cadena) {
    // Usamos " := " como delimitador
    char *token = strtok(cadena, " := ");

    if (token != NULL) {
        return token;
    } else {
        // No se encontró el delimitador, devolvemos la cadena original
        return cadena;
    }
}
%}

%token INICIO FIN ESCRIBIR LEER PARENTESIS_ABRE PARENTESIS_CIERRA COMA ASIGNACION SUMA RESTA NUMEROS ID PUNTOYCOMA

%type <cadena> ID
%type <numeros> NUMEROS

%union{
    char *cadena;
    int numeros;
}

%%

prog:
    | INICIO CODIGO FIN
;

CODIGO:
    | INSTRUCCION PUNTOYCOMA CODIGO
;

INSTRUCCION:
    | ESCRITURA
    | ASIGNACION_VARIABLE
    | LECTURA_DATOS
;

/*------------------EXPRESIONES-------------------------*/

/*------------------ESCRITURA-------------------------*/
ESCRITURA:
    ESCRIBIR PARENTESIS_ABRE ARGUMENTOS_ESCRITURA PARENTESIS_CIERRA
;

ARGUMENTOS_ESCRITURA:
    ARGUMENTO_ESCRITURA
    | ARGUMENTO_ESCRITURA COMA ARGUMENTOS_ESCRITURA
;

ARGUMENTO_ESCRITURA:
    NUMEROS {printf("\"%d\"\n", $1);}
    | ID {
        int index = buscar_variable($1);
        if (index != -1) {
            printf("%d\n", tabla_simbolos[index].valor);
        } else {
            fprintf(stderr, "Error: Variable no definida: %s\n", $1);
            exit(1);
        }
    }
;

/*------------------DECLARACION VARIABLE-------------------------*/

ASIGNACION_VARIABLE:
    ID ASIGNACION NUMEROS {
        int index = buscar_variable(obtenerVariable($1));
        if (index != -1) {
            tabla_simbolos[index].valor = $3;
        } else {
            if (num_variables < MAX_VARIABLES) {
                tabla_simbolos[num_variables].nombre = obtenerVariable($1);
                tabla_simbolos[num_variables].valor = $3;
                num_variables++;
            } else {
                fprintf(stderr, "Error: Demasiadas variables.\n");
                exit(1);
            }
        }
    }
;

LECTURA_DATOS:
    LEER PARENTESIS_ABRE ARGUMENTOS_LECTURA PARENTESIS_CIERRA
;

ARGUMENTOS_LECTURA:
    ID {
        char variable[100];
        printf("Ingrese el valor para %s: ", $1);
        scanf("%s", variable);
        int index = buscar_variable(obtenerVariable($1));
        if (index != -1) {
            tabla_simbolos[index].valor = atoi(variable);
        } else {
            if (num_variables < MAX_VARIABLES) {
                tabla_simbolos[num_variables].nombre = obtenerVariable($1);
                tabla_simbolos[num_variables].valor = atoi(variable);
                num_variables++;
            } else {
                fprintf(stderr, "Error: Demasiadas variables.\n");
                exit(1);
            }
        }
    }
;
%%

int yyerror(char *s){
	printf("\n¡¡¡Error Sintactico: %s!!!\n",s);
}

int main(int argc,char **argv){
    yyparse();
    return 0;
}