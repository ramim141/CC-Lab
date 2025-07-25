%{
#include "cal.tab.h"
#include <stdlib.h>
%}

%%
"int"           { return INT; }
"for"           { return FOR; }
"return"        { return RETURN; }
[0-9]+           { yylval.ival = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return ID; }
"=="|"!="|">="|"<="|">"|"<" { yylval.sval = strdup(yytext); return RELOP; }
"="             { return ASSIGN; }
";"             { return SEMI; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
"\+"            { return PLUS; }
[ \t\n]+         { /* skip whitespace */ }
.                { return yytext[0]; }
%%

int yywrap() {
    return 1;
}
