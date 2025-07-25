%{
#include <stdio.h>

#include "cal.tab.h"
%}


%%


"int"                   { return INT; }
"main"                  { return MAIN; }
"void"                  { return VOID; } 
"return"                { return RETURN; }
"printf"                { return PRINTF; }
"scanf"                 { return SCANF; }
"switch"                { return SWITCH; }
"case"                  { return CASE; }
"default"               { return DEFAULT; }
"break"                 { return BREAK; }


[a-zA-Z_][a-zA-Z0-9_]*    { return IDENTIFIER; }


[0-9]+                  { return INTEGER_LITERAL; } 
\"[^"]*\"               { return STRING_LITERAL; } 
"%d"                    { return FORMAT_SPECIFIER; }


"+"                       { return PLUS; }
"/"                       { return DIVIDE; }
"="                       { return ASSIGN; }
";"                       { return SEMICOLON; }
"("                       { return LPAREN; }
")"                       { return RPAREN; }
"{"                       { return LBRACE; }
"}"                       { return RBRACE; }
","                       { return COMMA; }
":"                       { return COLON; }
"%"                       { return MODULO; } 
"&"                       { return AMPERSAND; } 


[ \t\n]+                { /* Ignore spaces, tabs, newlines */ }


.                         { fprintf(stderr, "Lexer Error: Unexpected character '%s'\n", yytext); }
%%

/*
 * yywrap() function is called when the lexer reaches the end of the input file.
 * Returning 1 signifies that there are no more files to process.
 */
int yywrap() {
    return 1;
}