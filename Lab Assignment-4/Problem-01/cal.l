%option noyywrap

%{
#include "cal.tab.h"
#include <stdlib.h>
%}

digit      [0-9]+
float      [0-9]+\.[0-9]+
ws         [ \t\r\n]+

%%

{float}    { yylval.fval = atof(yytext); return FLOAT_NUM; }
{digit}    { yylval.ival = atoi(yytext); return INT_NUM; }
"+"        { return ADD; }
"-"        { return SUB; }
"*"        { return MUL; }
"/"        { return DIV; }
"("        { return '('; }
")"        { return ')'; }
{ws}       { /* skip whitespace */ }
.          { /* ignore any other character */ }

%%