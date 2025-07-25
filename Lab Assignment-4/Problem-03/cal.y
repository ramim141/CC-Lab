%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *s);
int yylex();
%}

%union {
    int ival;
    char *sval;
}

%token <sval> ID
%token <ival> NUMBER
%token INT IF RETURN TRUE
%token <sval> RELOP
%token ASSIGN SEMI LPAREN RPAREN LBRACE RBRACE

%%
program:
    stmt_list
    ;

stmt_list:
    stmt_list stmt
    | stmt
    ;

stmt:
    decl_stmt
    | if_stmt
    | return_stmt
    ;

decl_stmt:
    INT ID ASSIGN NUMBER SEMI { printf("Declaration: int %s = %d\n", $2, $4); free($2); }
    ;

if_stmt:
    IF LPAREN ID RELOP ID RPAREN return_stmt { printf("If statement: if(%s %s %s)\n", $3, $4, $5); free($3); free($4); free($5); }
    ;

return_stmt:
    RETURN TRUE SEMI { printf("Return statement: return true\n"); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
} 