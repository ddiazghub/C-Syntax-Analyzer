/* simplest version of calculator */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *out; /* Archivo de salida */
FILE *yout;
int error_count = 0;
int line = 1;
int last_error = -1;

%}
/* declare tokens */
%token TYPE
%token MAIN IF ELSE WHILE FOR DO SWITCH CASE DEFAULT INPUT OUTPUT INCLUDE
%token ID
%token POPEN PCLOSE SCOPE_START SCOPE_END
%token COMMA COLON SEMICOLON
%token INT FLOAT CHAR STRING
%token ASSIGNMENT
%token HASH
%token HEADER_INCLUDE INCLUDE_LB

%left OR
%left AND
%left EQUAL NOT_EQUAL
%left GREATER_THAN GREATER_EQUAL SMALLER_EQUAL SMALLER_THAN
%left ADD SUBSTRACT
%left MULTIPLY DIVIDE MODULO
%left NOT UMINUS

%%

program: 
    | main_function
    | statement_list
    | statement_list main_function
    | main_function statement_list
    | statement_list main_function statement_list;

main_function: optional_type MAIN param_declaration scope;
optional_type: | TYPE;

param_declaration: POPEN PCLOSE
    | POPEN param_declaration_list PCLOSE
    | POPEN error scope
    | error PCLOSE
    | POPEN param_declaration_list error scope
    | error param_declaration_list PCLOSE;
    
param_declaration_list: declaration | param_declaration_list COMMA declaration;
declaration: TYPE ID;
var_declaration: TYPE var_declaration_list;

var_declaration_list: ID
    | var_assignment
    | var_declaration_list COMMA ID
    | var_declaration_list COMMA var_assignment;

var_assignment: ID ASSIGNMENT expression | ID ASSIGNMENT var_assignment;

var_op_assignment: ID ADD ADD
    | ADD ADD ID
    | ID SUBSTRACT SUBSTRACT
    | SUBSTRACT SUBSTRACT ID
    | ID ADD ASSIGNMENT expression
    | ID SUBSTRACT ASSIGNMENT expression
    | ID MULTIPLY ASSIGNMENT expression
    | ID DIVIDE ASSIGNMENT expression
    | ID MODULO ASSIGNMENT expression;

if_statement: IF parenthesis_expression statement | IF parenthesis_expression statement else_statement;
else_statement: ELSE if_statement | ELSE statement;
while_loop: WHILE parenthesis_expression statement;
for_loop: FOR POPEN single_statement expression SEMICOLON statement_body PCLOSE statement
    | FOR POPEN single_statement SEMICOLON PCLOSE statement
    | FOR POPEN single_statement expression SEMICOLON PCLOSE statement
    | FOR POPEN single_statement SEMICOLON statement_body PCLOSE statement;

do_while_loop: DO statement WHILE parenthesis_expression SEMICOLON;
switch_statement: SWITCH parenthesis_expression SCOPE_START switch_body SCOPE_END;

switch_body: | switch_case | switch_body switch_case;

switch_case: DEFAULT COLON
    | CASE non_string_literal COLON
    | DEFAULT COLON statement_list
    | CASE non_string_literal COLON statement_list
    | DEFAULT COLON scope
    | CASE non_string_literal COLON scope;

stdinput: INPUT POPEN STRING PCLOSE
    | INPUT POPEN STRING COMMA value_list PCLOSE;

stdoutput: OUTPUT POPEN STRING PCLOSE
    | OUTPUT POPEN STRING COMMA value_list PCLOSE;

statement_list: statement | statement_list statement;

statement: single_statement
    | preprocessor_directive
    | scope
    | if_statement
    | else_statement
    | while_loop
    | for_loop
    | do_while_loop
    | switch_statement;

scope: SCOPE_START SCOPE_END | SCOPE_START statement_list SCOPE_END;
single_statement: statement_body SEMICOLON | error SEMICOLON;
statement_body: | var_declaration
    | var_op_assignment
    | var_declaration_list
    | expression
    | stdinput
    | stdoutput;

preprocessor_directive: HASH INCLUDE directive_body INCLUDE_LB
    | HASH error INCLUDE_LB;

directive_body: HEADER_INCLUDE | STRING; 

parenthesis_expression: POPEN expression PCLOSE;
expression: value
    | parenthesis_expression
    | expression OR expression
    | expression AND expression
    | expression EQUAL expression
    | expression NOT_EQUAL expression
    | expression GREATER_EQUAL expression
    | expression GREATER_THAN expression
    | expression SMALLER_EQUAL expression
    | expression SMALLER_THAN expression
    | expression ADD expression
    | expression SUBSTRACT expression
    | expression MULTIPLY expression
    | expression DIVIDE expression
    | expression MODULO expression
    | NOT expression
    | SUBSTRACT expression %prec UMINUS;

value: literal | ID
value_list: value | value COMMA value_list;
non_string_literal: INT | FLOAT | CHAR;
literal: INT | FLOAT | CHAR | STRING;

%%
int main(int argc, char **argv) {
    char *filename;

    if (argc == 2) {
        filename = argv[1];
    } else {
        printf("No se suministró archivo de entrada. Se utilizará \"prueba.c\" por defecto.\n");
        filename = "prueba.c";
    }

    // Se abre el archivo de entrada en modo de lectura
    extern FILE *yyin;
    yyin = fopen(filename, "r");

    // Si no se puede abrir se muestra un error
    if (yyin == NULL) {
        fprintf(stderr, "No se pudo abrir el archivo de entrada \"%s\". Asegúrese que este existe.\n", filename);

        return 1;
    }

    // Se abre el archivo de salida en modo de escritura
    out = fopen("salida.txt", "w");
    
    // Si no se puede abrir se muestra un error
    if (out == NULL) {
        fprintf(stderr, "No se pudo abrir el archivo de salida léxico");

        return 1;
    }

    // Se abre el archivo de salida en modo de escritura
    yout = fopen("saliday.txt", "w");
    
    // Si no se puede abrir se muestra un error
    if (out == NULL) {
        fprintf(stderr, "No se pudo abrir el archivo de salida sintáctico");

        return 1;
    }

    fprintf(yout, "Prueba con el archivo de entrada\n");

    // Se ejecuta el análisis léxico del programa
    yyparse();
    fclose(yyin);
    fclose(out);
    
    switch (error_count) {
        case 0:
            fprintf(yout, "\nBien.\n");
            break;
        
        case 1:
            fprintf(yout, "\nLínea erronea.\n");
            break;

        default:
            fprintf(yout, "\n%d líneas erroneas.\n", error_count);
            break;
    }

    fclose(yout);

    return 0;
}

int yyerror(char *s) {
    if (line > last_error) {
        error_count++;
        fprintf(yout, "Error sintáctico en línea número: %d\n", line);
        last_error = line;
    }
}