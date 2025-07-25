

%{
#include <stdio.h>
#include <stdlib.h> 


extern int yylex();   
extern int yyparse(); 
void yyerror(const char *s); 
%}


%token INT RETURN VOID MAIN PRINTF SCANF SWITCH CASE DEFAULT BREAK
%token IDENTIFIER INTEGER_LITERAL STRING_LITERAL FORMAT_SPECIFIER AMPERSAND
%token PLUS DIVIDE ASSIGN SEMICOLON LPAREN RPAREN LBRACE RBRACE COMMA COLON MODULO

%right ASSIGN

%left PLUS
%left DIVIDE MODULO


%start program

%%


program:
    function_definition
    ;

function_definition:
    INT MAIN LPAREN RPAREN LBRACE
        declarations
        statement_list
    RBRACE
    ;

declarations:
    declaration
    | declarations declaration
    | 
    ;

declaration:
    INT IDENTIFIER SEMICOLON
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    simple_statement
    | switch_statement
    ;

simple_statement:
    expression_statement
    | function_call SEMICOLON 
    | RETURN expression SEMICOLON
    | BREAK SEMICOLON
    ;


function_call:
    PRINTF LPAREN argument_list RPAREN
    | SCANF LPAREN argument_list RPAREN
    ;


argument_list:
    argument
    | argument_list COMMA argument
    ;


argument:
    STRING_LITERAL 
    | FORMAT_SPECIFIER 
    | IDENTIFIER 
    | unary_expression 
    ;


unary_expression:
    AMPERSAND IDENTIFIER
    ;

expression_statement:
    expression SEMICOLON
    | SEMICOLON 
    ;

expression:
    assignment_expression
    | arithmetic_expression
    | STRING_LITERAL 
    | FORMAT_SPECIFIER 
    ;

assignment_expression:
    IDENTIFIER ASSIGN expression
    ;

arithmetic_expression:
    expression PLUS expression
    | expression DIVIDE expression
    | expression MODULO expression
    | LPAREN expression RPAREN
    | IDENTIFIER
    | INTEGER_LITERAL
    ;

switch_statement:
    SWITCH LPAREN expression RPAREN LBRACE
        case_clauses
        default_clause
    RBRACE
    ;

// Allow multiple case labels, each optionally followed by statements (including empty)
case_clauses:
    /* empty */
    | case_clause case_clauses
    ;

case_clause:
    CASE INTEGER_LITERAL COLON case_body
    ;

case_body:
    /* empty */
    | statement_list
    ;

default_clause:
    DEFAULT COLON
        statement_list
    | 
    ;

%%


void yyerror(const char *s) {
    fprintf(stderr, "Parser Error: %s\n", s);
}


int main() {
    printf("Starting parser for the given C code...\n");
    if (yyparse() == 0) {
        printf("Parsing successful!\n");
    } else {
        fprintf(stderr, "Parsing failed.\n");
        return 1;
    }
    return 0;
}