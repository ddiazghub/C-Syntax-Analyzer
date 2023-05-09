%{
/* Librerías */
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "LAB02_Diaz_Poveda_Fajardo.tab.h"

#define CAPACITY 1000

/* DECLARACIÓN DE FUNCIONES */
void id_table_print();
void id_table_add(char *id); /* Añade un elemento a una lista de cadenas */
void id_table_free(); /* Libera el espacio ocupado en memoria por una lista de cadenas */
void error(char *err);
void error_free();
int id_table_search(char *id); /* Busca linealmente un elemento en una lista de cadenas y retorna su posición si se encuentra */
char *str_to_upper(char *string); /* Convierte una cadena entera en mayúsculas */

/* VARIABLES GLOBALES */
extern FILE *out;
extern int line;
char buffer[1000];
int indent = 0; /* Nivel de indentado con el cual se escribirá en el archivo de salida */
char *id_table[CAPACITY];
char *lexical_errors[CAPACITY];
int error_lines[CAPACITY];
int n_errors = 0;
int id_table_size = 0;

%}

/* DEFINICIONES REGULARES */
DATA_TYPE (short|int|long|char|float|double|void|NULL)
IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*
UNSIGNED [0-9]+
UNSIGNED_HEX 0x[0-9a-fA-F]+
DECIMAL_INT \-?{UNSIGNED}
HEX_INT \-?{UNSIGNED_HEX}
INT_LITERAL {DECIMAL_INT}|{HEX_INT}|{DECIMAL_INT}e{DECIMAL_INT}
FLOAT_LITERAL {DECIMAL_INT}(\.{UNSIGNED})(e{DECIMAL_INT})?
OCTAL_CHARACTER [0-7]{1,3}
HEX_CHARACTER x[0-9a-fA-F]{1,2}
CHAR_ESC_SEQ \\([abefnrtv\\'\"\?]|{OCTAL_CHARACTER}|{HEX_CHARACTER})
CHAR_LITERAL '([^'\\\n]|{CHAR_ESC_SEQ})'
UNICODE_CHARACTER u[0-9a-fA-F]{4}
LONG_UNICODE_CHARACTER U[0-9a-fA-F]{8}
STRING_LITERAL \"([^\\\n\"]|{CHAR_ESC_SEQ}|\\({UNICODE_CHARACTER}|{LONG_UNICODE_CHARACTER}))*\"
H_INCLUDE <[^\n>]*>
COMMENT_LINE \/\/[^\n]*
LEXICAL_ERROR [a-zA-z0-9]*[^a-zA-Z0-9 \_\t\r\n\v\=\!\*\+\-\/\%\(\)\,\<\>\&\|\{\}\;\:\#]+[^ \_\t\r\n\v\=\!\*\+\-\/\%\(\)\,\<\>\&\|\{\}\;\:\#]*|[0-9]+[a-zA-Z][a-zA-z0-9]*

/* CONDICIONES INICIALES */
%s COMMENT_BLOCK
%s INCLUDE_HEADER
/* PROCEDIMIENTOS A REALIZAR CUANDO SE ENCUENTRA UN LEXEMA */
%%

{COMMENT_LINE} fprintf(out, "%s\n%*s", yytext, 2 * indent, "");

"/*" {
    fprintf(out, "%s", yytext);
    BEGIN(COMMENT_BLOCK);
}
<COMMENT_BLOCK>[^\n\*]* fprintf(out, "%s", yytext);
<COMMENT_BLOCK>"*" fprintf(out, "%s", yytext);
<COMMENT_BLOCK>"*/" {
    fprintf(out, "*/\n%*s", 2 * indent, "");
    BEGIN(0);
}

<COMMENT_BLOCK>\n { fprintf(out, "\n%*s", 2 * indent, ""); line++; }
<INCLUDE_HEADER>\n {
    line++;
    BEGIN(0);
    return INCLUDE_LB;
}

<INITIAL>\n line++;

{DATA_TYPE} {
    /* Cuando se encuentra un tipo se escribe este en mayúscula */
    yylval = yytext;
    fprintf(out, "%s ", str_to_upper(yytext));

    return TYPE;
}

main {
    fprintf(out, "%s ", str_to_upper(yytext));
    return MAIN;
}

if {
    fprintf(out, "%s ", str_to_upper(yytext));
    return IF;
}

else {
    fprintf(out, "%s ", str_to_upper(yytext));
    return ELSE;
}

while {
    fprintf(out, "%s ", str_to_upper(yytext));
    return WHILE;
}

for {
    fprintf(out, "%s ", str_to_upper(yytext));
    return FOR;
}

do {
    fprintf(out, "%s ", str_to_upper(yytext));
    return DO;
}

switch {
    fprintf(out, "%s ", str_to_upper(yytext));
    return SWITCH;
}

case {
    fprintf(out, "%s ", str_to_upper(yytext));
    return CASE;
}

default {
    fprintf(out, "%s ", str_to_upper(yytext));
    return DEFAULT;
}

scanf {
    fprintf(out, "%s ", str_to_upper(yytext));
    return INPUT;
}

printf {
    fprintf(out, "%s ", str_to_upper(yytext));
    return OUTPUT;
}

include {
    fprintf(out, "%s ", str_to_upper(yytext));
    return INCLUDE;
}

{IDENTIFIER} {
    int position = id_table_search(yytext);

    if (position == -1) {
        position = id_table_size;
        id_table_add(yytext);
    }

    fprintf(out, "ID_%d=%s ", position, yytext);
    return ID;
}

"#" { BEGIN(INCLUDE_HEADER); fprintf(out, "Numeral=# "); return HASH; }
"=" { fprintf(out, "Op-asign== "); return ASSIGNMENT; }
"==" { fprintf(out, "Igual=== "); return EQUAL; }
"!=" { fprintf(out, "Diferente=!= "); return NOT_EQUAL; }
">=" { fprintf(out, "Mayor-igual=>= "); return GREATER_EQUAL; }
"<=" { fprintf(out, "Menor-igual=<= "); return SMALLER_EQUAL; }
">" { fprintf(out, "Mayor=> "); return GREATER_THAN; }
"<" { fprintf(out, "Menor "); return SMALLER_THAN; }
"&&" { fprintf(out, "And=&& "); return AND; }
"||" { fprintf(out, "Or=|| "); return OR; }
"!" { fprintf(out, "No=! "); return NOT; }
"+" { fprintf(out, "Op-sum=+ "); return ADD; }
"-" { fprintf(out, "Op-sust=- "); return SUBSTRACT; }
"*" { fprintf(out, "Op-mult=* "); return MULTIPLY; }
"/" { fprintf(out, "Op-div=/ "); return DIVIDE; }
"%" { fprintf(out, "Op-mod=% "); return MODULO; }
"(" { fprintf(out, "Parent-a=( "); return POPEN; }
")" { fprintf(out, "Parent-c=) "); return PCLOSE; }

"{" { /* Una llave de apertura delimita el inicio de un nuevo alcance anidado, se incrementa la indentación */
    indent++;
    fprintf(out, "Inicio={\n%*s", 2 * indent, "");

    return SCOPE_START;
}

"}" { /* Una llave de apertura delimita el fin de un alcance */
    // Se decrementa la indentación
    if (indent > 0) {
        indent--;
        fseek(out, -2, SEEK_CUR);
    }

    // Se escribe el componente léxico de fin de alcance
    fprintf(out, "Fin=}\n%*s", 2 * indent, "");

    return SCOPE_END;
}

"," { fprintf(out, "Coma=, "); return COMMA; }

":" {
    fprintf(out, "Dos-puntos=:\n%*s", 2 * indent, "");
    
    return COLON;
}

";" { /* Punto y coma delimita el fin de una instrucción, despues del componente léxico y su lexema, se escribe un salto de linea y una cantidad de espacios que depende del indentado actual */
    fprintf(out, "Punto-coma=;\n%*s", 2 * indent, "");
    
    return SEMICOLON;
}

{INT_LITERAL} {
    yylval = atol(yytext);
    fprintf(out, "Cte-entera=%s ", yytext);

    return INT;
}

{FLOAT_LITERAL} {
    yylval = atof(yytext);
    fprintf(out, "Cte-real=%s ", yytext);

    return FLOAT;
}

{CHAR_LITERAL} {
    fprintf(out, "Cte-caractér=%s ", yytext);
    yytext[yyleng - 1] = '\0';

    switch (yyleng) {
    case 3:
        yylval = yytext[1];
        break;

    case 4:
        switch (yytext[2]) {
        case 'a':
            yylval = '\a';
            break;

        case 'b':
            yylval = '\b';
            break;
            
        case 'e':
            yylval = '\e';
            break;
            
        case 'f':
            yylval = '\f';
            break;
            
        case 'n':
            yylval = '\n';
            break;
            
        case 'r':
            yylval = '\r';
            break;
            
        case 't':
            yylval = '\t';
            break;

        case 'v':
            yylval = '\v';
            break;
            
        case '?':
            yylval = '\?';
            break;

        case '\\':
        case '\'':
        case '\"':
            yylval = yytext[2];
        }

        break;
        
    case 5:
        yylval = (char) strtol(yytext + 1, NULL, 8);
        break;

    default:
        yylval = (char) strtol(yytext + 1, NULL, 16);
        break;
    }

    return CHAR;
}

{STRING_LITERAL} {
    fprintf(out, "Cte-cadena=%s ", yytext);
    yytext[yyleng - 1] = '\0';
    yylval = yytext + 1;

    return STRING;
}

{H_INCLUDE} {
    fprintf(out, "Cabecera=%s\n", yytext);
    yytext[yyleng - 1] = '\0';
    yylval = yytext + 1;

    return HEADER_INCLUDE;
}

[ \t\r] {}

{LEXICAL_ERROR} {
    error(yytext);
    fprintf(out, "Error-léxico=%s ", yytext);
    return *yytext;
}

<<EOF>> {
    fprintf(out, "\nTABLA DE IDENTIFICADORES\nHay %d identificadores\n", id_table_size);

    for (int i = 0; i < id_table_size; i++)
        fprintf(out, "Id_%d=%s; ", i, id_table[i]);

    if (n_errors > 0) {
        fprintf(out, "\n\nERRORES LÉXICOS\n");

        for (int i = 0; i < n_errors; i++)
            fprintf(out, "Error léxico en línea %d: %s\n", error_lines[i], lexical_errors[i]);
    }

    id_table_free();
    error_free();

    return 0;
}

. {
    error(yytext);
    fprintf(out, "Error-léxico=%s ", yytext);
    return *yytext;
}

%%

/* Convierte una cadena entera en mayúsculas */
char *str_to_upper(char *string) {
    int i = 0;

    // Copia la cadena mientras convierte cada caractér en mayúscula
    for ( ; string[i] != '\0'; i++)
        buffer[i] = (char) toupper(string[i]);

    // Añade el caractér que delimita el fin de la cadena al final
    buffer[i] = '\0';

    return buffer;
}

/* Añade un elemento a una lista de cadenas */
void id_table_add(char *id) {
    if (id_table_size < CAPACITY) {
        size_t len = strlen(id);
        char *new_id = (char *) malloc(len * sizeof(char) + 1);
        strcpy(new_id, id);
        id_table[id_table_size] = new_id;
        id_table_size++;
    }
}

void id_table_print() {
    if (id_table_size == 0) {
        printf("[]");
    } else {
        printf("[%s", id_table[0]);

        for (int i = 1; i < id_table_size; i++)
            printf(", %s", id_table[i]);

        printf("]\n");
    }
}

void id_table_free() {
    for (int i = 0; i < id_table_size; i++)
        free(id_table[i]);
}

int id_table_search(char *id) {
    // Busqueda lineal
    for (int i = 0; i < id_table_size; i++)
        if (strcmp(id_table[i], id) == 0)
            return i;

    return -1;
}

void error(char *error) {
    if (n_errors < CAPACITY) {
        size_t len = strlen(error);
        char *new_error = (char *) malloc(len * sizeof(char) + 1);
        strcpy(new_error, error);
        lexical_errors[n_errors] = new_error;
        error_lines[n_errors] = line;
        n_errors++;
    }
}

void error_free() {
    for (int i = 0; i < n_errors; i++)
        free(lexical_errors[i]);
}