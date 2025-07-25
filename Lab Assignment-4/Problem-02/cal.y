%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_VARS 100
struct { char name[32]; double value; } symtab[MAX_VARS];
int symtab_len = 0;
double get_var(const char* name) {
    for(int i=0;i<symtab_len;i++) if(strcmp(symtab[i].name,name)==0) return symtab[i].value;
    return 0;
}
void set_var(const char* name, double value) {
    for(int i=0;i<symtab_len;i++) if(strcmp(symtab[i].name,name)==0) { symtab[i].value = value; return; }
    strcpy(symtab[symtab_len].name, name); symtab[symtab_len++].value = value;
}
void yyerror(const char *s);
int yylex(void);
%}

%union {
    int ival;
    double fval;
    char* sval;
}

%token <ival> INT_NUM
%token <fval> FLOAT_NUM
%token <sval> ID
%token ASSIGN ADD SUB MUL DIV SEMI
%left ADD SUB
%left MUL DIV
%type <fval> expr
%type <fval> stmt

%start stmt_list

%%
stmt_list:
    /* empty */
    | stmt_list stmt
    ;

stmt:
    ID ASSIGN expr SEMI { set_var($1, $3); printf("%s = %g\n", $1, $3); free($1); $$ = $3; }
    | expr SEMI         { printf("Result: %g\n", $1); $$ = $1; }
    ;

expr:
    ID           { $$ = get_var($1); free($1); }
    | INT_NUM    { $$ = $1; }
    | FLOAT_NUM  { $$ = $1; }
    | expr ADD expr { $$ = $1 + $3; }
    | expr SUB expr { $$ = $1 - $3; }
    | expr MUL expr { $$ = $1 * $3; }
    | expr DIV expr { $$ = $1 / $3; }
    | '(' expr ')'  { $$ = $2; }
    ;

%%

void yyerror(const char *s)
{
    fprintf(stderr, "Error: %s\n", s);
    printf("parsing finished\n");
}

int main(void)
{
    yyparse();
    return 0;
}
