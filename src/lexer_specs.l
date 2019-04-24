%{
#include "tokens.h"
%}

%{
// =====================================================================================================
// Start States
// ============
%}

%s BLOCK_COMMENT

%{
// =====================================================================================================
// Pattern Definitions (Substitutions)
// ===================================
%}

DIGIT               [0-9]
INTEGER             [0-9]+
FLOAT               ([0-9]*\.[0-9]+)|([0-9]+\.[0-9]*)
EXP                 [eE][-+]?{INTEGER}
REAL                ({INTEGER}{EXP}|{FLOAT}({EXP})?)
LETTER              [a-zA-Z_]
IDENTIFIER          {LETTER}({LETTER}|{DIGIT})*
LINE_COMMENT        "//"(.)*\n
WHITESPACE          [ \t\n]+

%%

%{
// =====================================================================================================
// Rules Section
// =============
%}

%{
// Data types
%}
<INITIAL>"int"                  { return TYPE_INT; }
<INITIAL>"float"                { return TYPE_FLOAT; }
<INITIAL>"char"                 { return TYPE_CHAR; }
<INITIAL>"bool"                 { return TYPE_BOOL; }
<INITIAL>"void"                 { return TYPE_VOID; }

%{
// Branch tokens
%}
<INITIAL>"const"                { return COSNT; }
<INITIAL>"if"                   { return IF; }
<INITIAL>"switch"               { return SWITCH; }
<INITIAL>"default"              { return DEFAULT; }
<INITIAL>"for"                  { return FOR; }
<INITIAL>"do"                   { return DO; }
<INITIAL>"while"                { return WHILE; }
<INITIAL>"break"                { return BREAK; }
<INITIAL>"continue"             { return CONTINUE; }
<INITIAL>"return"               { return RETURN; }

%{
// Operators
%}
<INITIAL>"=="                   { return EQUAL; }
<INITIAL>"!="                   { return NOT_EQUAL; }
<INITIAL>">="                   { return GREATER_EQUAL; }
<INITIAL>"<="                   { return LESS_EQUAL; }
<INITIAL>">>"                   { return SHIFT_LEFT; }
<INITIAL>"<<"                   { return SHIFT_RIGHT; }
<INITIAL>"&&"                   { return LOGICAL_AND; }
<INITIAL>"||"                   { return LOGICAL_OR; }
<INITIAL>[-+*/%&|^~!<>=]        { return yytext[0]; }

%{
// Values
%}
<INITIAL>{INTEGER}              { return INTEGER; }
<INITIAL>{REAL}                 { return FLOAT; }
<INITIAL>(\'.\')                { return CHAR; }
<INITIAL>("true"|"false")       { return BOOL; }
<INITIAL>{IDENTIFIER}           { return IDENTIFIER; }

%{
// Others
%}
<INITIAL>[(){};]                { return yytext[0]; }
<INITIAL>{WHITESPACE}           ; // Ignore whitespace
<INITIAL>{LINE_COMMENT}         ; // Ignore comments
<INITIAL>"/*"                   BEGIN BLOCK_COMMENT;
<BLOCK_COMMENT>"*/"             BEGIN INITIAL;
<BLOCK_COMMENT>(.|\n)           ; // Ignore block comments

%%

// =====================================================================================================
// User Subroutines Section
// ========================

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}