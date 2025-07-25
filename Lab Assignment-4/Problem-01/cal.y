%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(char *s);
int yylex();

static double result = 0;
%}

%union {
    int ival;
    double fval;
}

%token <ival> INT_NUM
%token <fval> FLOAT_NUM
%token ADD SUB MUL DIV
%left ADD SUB
%left MUL DIV
%type <fval> expr term factor

%start expr

%%

expr: expr ADD term   { $$ = $1 + $3; result = $$; }
    | expr SUB term   { $$ = $1 - $3; result = $$; }
    | term            { $$ = $1; result = $$; }
    ;

term: term MUL factor { $$ = $1 * $3; }
    | term DIV factor { $$ = $1 / $3; }
    | factor          { $$ = $1; }
    ;

factor: INT_NUM       { $$ = $1; }
      | FLOAT_NUM     { $$ = $1; }
      | '(' expr ')'  { $$ = $2; }
      ;

%%

void yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}

int main()
{
    if (yyparse() == 0)
        printf("Result: %g\n", result);
    return 0;
}