%{
static std::string last_token;
#define SAVE_TOKEN last_token = std::string(yytext, yyleng)
%}

%%

[ \t\n]					;
[a-zA-Z_][a-zA-Z0-9_]* 	{ SAVE_TOKEN; return TIDENTIFIER; }
[0-9]+\.[0-9]* 			{ SAVE_TOKEN; return TDOUBLE; }
[0-9]+					{ SAVE_TOKEN; return TINTEGER; }
"="						return TEQUAL;
"=="					return TCEQ;
"!="					return TCNE;
"<"						return TCLT;
"<="					return TCLE;
">"						return TCGT;
">="					return TCGE;
"("						return TLPAREN;
")"						return TRPAREN;
"{"						return TLBRACE;
"}"						return TRBRACE;
"."						return TDOT;
","						return TCOMMA;
"+"						return TPLUS;
"-"						return TMINUS;
"*"						return TMUL;
"/"						return TDIV;

%%
