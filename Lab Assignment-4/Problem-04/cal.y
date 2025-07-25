%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_VARS 100
struct { char name[32]; int value; } symtab[MAX_VARS];
int symtab_len = 0;

int get_var(const char* name) {
    for(int i=0;i<symtab_len;i++) if(strcmp(symtab[i].name,name)==0) return symtab[i].value;
    return 0;
}
void set_var(const char* name, int value) {
    for(int i=0;i<symtab_len;i++) if(strcmp(symtab[i].name,name)==0) { symtab[i].value = value; return; }
    strcpy(symtab[symtab_len].name, name); symtab[symtab_len++].value = value;
}

void yyerror(const char *s);
int yylex();
%}

%union {
    int ival;
    char *sval;
}

%token <sval> ID
%token <ival> NUMBER
%token FOR
%token <sval> RELOP
%token ASSIGN SEMI LPAREN RPAREN LBRACE RBRACE PLUS
%token INT
%token RETURN

%type <ival> expr
%type <ival> block

%%
program:
    stmt_list
    ;

stmt_list:
    /* empty */
    | stmt_list stmt
    | stmt
    ;

stmt:
    for_stmt
    | assign_stmt
    | decl_stmt
    | return_stmt
    | block
    ;

decl_stmt:
    INT ID ASSIGN expr SEMI { set_var($2, $4); free($2); }
    ;

block:
    LBRACE stmt_list RBRACE { }
    ;

for_stmt:
    FOR LPAREN assign_expr SEMI expr SEMI assign_expr RPAREN block {
        int i;
        int start = get_var("i");
        int end = 10;
        for(i = start; i <= end; i = i + 1) {
            set_var("i", i);
            set_var("sum", get_var("sum") + i);
        }
    }
    ;

assign_stmt:
    ID ASSIGN expr SEMI { set_var($1, $3); free($1); }
    ;

assign_expr:
    ID ASSIGN expr { set_var($1, $3); free($1); }
    ;

expr:
    ID { $$ = get_var($1); free($1); }
    | NUMBER { $$ = $1; }
    | expr RELOP expr {
        if(strcmp($2, "<") == 0) $$ = $1 < $3;
        else if(strcmp($2, "<=") == 0) $$ = $1 <= $3;
        else if(strcmp($2, ">") == 0) $$ = $1 > $3;
        else if(strcmp($2, ">=") == 0) $$ = $1 >= $3;
        else if(strcmp($2, "==") == 0) $$ = $1 == $3;
        else if(strcmp($2, "!=") == 0) $$ = $1 != $3;
        free($2);
    }
    | expr PLUS expr { $$ = $1 + $3; }
    | expr ASSIGN expr { $$ = $3; }
    ;

return_stmt:
    RETURN expr SEMI { printf("Result: %d\n", $2); }
    ;
    printf("parsing finished\n");

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    
    return 0;
}
