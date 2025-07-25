%option noyywrap

%{
#include "cal.tab.h"
#include <stdlib.h>
#include <string.h>
%}

digit      [0-9]+
float      [0-9]+\.[0-9]+
ws         [ \t\r\n]+
id         [a-zA-Z_][a-zA-Z0-9_]*

%%
{float}    { yylval.fval = atof(yytext); return FLOAT_NUM; }
{digit}    { yylval.ival = atoi(yytext); return INT_NUM; }
{id}       { yylval.sval = strdup(yytext); return ID; }
"="        { return ASSIGN; }
"+"        { return ADD; }
"-"        { return SUB; }
"*"        { return MUL; }
"/"        { return DIV; }
"("        { return '('; }
")"        { return ')'; }
";"        { return SEMI; }
{ws}       { /* skip whitespace */ }
.          { /* ignore any other character */ }
%%
