%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
	void yyerror(const char *s);
	extern int lineno;
	extern int yylex();
%}

%union
{
    char str_val[100];
    int int_val;
    float float_val;
    char char_val;
}

%token INT IF ELSE WHILE RETURN CONTINUE BREAK PRINT DOUBLE CHAR
%token ADDOP SUBOP MULOP DIVOP EQUOP LT GT
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN
%token<str_val> ID
%token<int_val> ICONST
%token<float_val> FCONST
%token<char_val> CCONST

%right ASSIGN
%left LT GT EQUOP
%left ADDOP SUBOP
%left MULOP DIVOP
%right UNARY

%type<int_val> type exp constant

%start program

%%

program: statements ;

statements: statements statement | ;

statement:  declaration
           | assignment_statement
           | if_statement
           | while_statement
           | return_statement
           | SEMI
            ;

declaration: type ID SEMI
            {
                insert($2, $1);
            }
            | type ID
            {
                insert($2, $1);
            }
            | type ID ASSIGN exp SEMI
            {
                insert($2, $1);
            }
            ;

assignment_statement: ID ASSIGN exp SEMI
                    {
                        if(!idcheck($1))
                        {
                            printf("In line no %d, Variable %s is not declared.\n", lineno, $1);
                        }
                    }
                    ;

type: INT {$$=INT_TYPE;}
    | DOUBLE {$$=REAL_TYPE;}
    | CHAR {$$=CHAR_TYPE;}
    ;

exp: constant
    {
        $$ = $1;
    }
    | ID 
    {
        if(idcheck($1))
        {
            $$ = gettype($1);
        }
        else
        {
            $$ = UNDEF_TYPE;
        }
    }
    | exp ADDOP exp { $$ = typecheck($1, $3); }
    | exp SUBOP exp { $$ = typecheck($1, $3); }
    | exp MULOP exp { $$ = typecheck($1, $3); }
    | exp DIVOP exp { $$ = typecheck($1, $3); }
    | exp GT exp    { $$ = typecheck($1, $3); }
    | exp LT exp    { $$ = typecheck($1, $3); }
    | ADDOP exp %prec UNARY
    | SUBOP exp %prec UNARY
    | LPAREN exp RPAREN { $$ = $2; }
    ;

constant: ICONST {$$=INT_TYPE;}
        | FCONST {$$=REAL_TYPE;}
        | CCONST {$$=CHAR_TYPE;}
        ;

while_statement: WHILE LPAREN exp RPAREN LBRACE statements RBRACE;

return_statement: RETURN exp SEMI;

if_statement: IF LPAREN exp RPAREN LBRACE statements RBRACE else_part;

else_part: ELSE if_statement
          | ELSE LBRACE statements RBRACE 
          | 
          ;

%%

void yyerror (const char *s)
{
	fprintf(stderr, "Syntax error: %s at line %d\n", s, lineno);
	exit(1);
}

int main (int argc, char *argv[])
{
	yyparse();
	printf("Parsing finished successfully!\n");	
	return 0;
}