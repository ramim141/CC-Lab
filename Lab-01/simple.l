/* Declarations */
%{
#include <stdio.h>

int line_num = 1;
%}

/* Rules */
%%
[ \t]           ; /* Skip whitespace */
\n              { line_num++; return EOL; /* Return EOL token for end of line */ }
[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9_]*  { yylval.id = strdup(yytext); return IDENTIFIER; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULTIPLY; }
"/"             { return DIVIDE; }
"="             { return EQUALS; }
.               { yyerror("Unknown character"); }
%%

/* C code */
// Remove the main function from here, it will be in the Yacc file.
// int main() {
//     yylex();
//     return 0;
// }

int yywrap() {
    return 1;
}