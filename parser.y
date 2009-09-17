%{
#include <iostream>
#include <typeinfo>
#include "node.h"
#include "tokens.inc"
#define DEBUG std::cout << typeid(*yyval.YYSTYPE::block).name() << std::endl;

void yyerror(const char *);
void debug(char *, Node*);
NBlock *programBlock;
%}

%union {
	Node *node;
	NBlock *block;
	NExpression *expr;
	NStatement *stmt;
	NIdentifier *ident;
	NVariableDeclaration *var_decl;
	std::vector<NVariableDeclaration*> *varvec;
	std::vector<NExpression*> *exprvec;
	int token;
}

%token <node> TIDENTIFIER
%token <node> TINTEGER TDOUBLE
%token <token> TCEQ TCNE TCLT TCLE TCGT TCGE TEQUAL
%token <token> TLPAREN TRPAREN TLBRACE TRBRACE TCOMMA TDOT
%type <ident> ident
%type <expr> numeric expr 
%type <varvec> func_decl_args
%type <exprvec> call_args
%type <block> program stmts block
%type <stmt> stmt var_decl func_decl
%type <token> comparison

%start program

%%

program : stmts { programBlock = $1; }
		;
		
stmts : stmt { $$ = new NBlock(); $$->statements.push_back($<stmt>1); }
	  | stmts stmt { $1->statements.push_back($<stmt>2); }
	  ;

stmt : var_decl | func_decl
	 | expr { $$ = new NExpressionStatement(*$1); }
     ;

block : TLBRACE stmts TRBRACE { $$ = $2; }
	  | TLBRACE TRBRACE { $$ = new NBlock(); }
	  ;

var_decl : ident ident { $$ = new NVariableDeclaration(*$1, *$2); }
		 | ident ident TEQUAL expr { $$ = new NVariableDeclaration(*$1, *$2, $4); }
		 ;
		
func_decl : ident ident TLPAREN func_decl_args TRPAREN block 
			{ $$ = new NFunctionDeclaration(*$1, *$2, *$4, *$6); delete $4; }
		  ;
	
func_decl_args : /*blank*/  { $$ = new std::vector<NVariableDeclaration*>(); }
		  | var_decl { $$ = new std::vector<NVariableDeclaration*>(); $$->push_back($<var_decl>1); }
		  | func_decl_args TCOMMA var_decl { $1->push_back($<var_decl>3); }
		  ;

ident : TIDENTIFIER { $$ = new NIdentifier(last_token); }
	  ;

numeric : TINTEGER { $$ = new NInteger(atol(last_token.c_str())); }
		| TDOUBLE { $$ = new NDouble(atof(last_token.c_str())); }
		;
	
expr : ident TEQUAL expr { $$ = new NAssignment(*$<ident>1, *$3); }
	 | ident TLPAREN call_args TRPAREN { $$ = new NMethodCall(*$1, *$3); delete $3; }
	 | ident { $<ident>$ = $1; }
	 | numeric
	 | expr comparison expr { $$ = new NBinaryOperator(*$1, (int)$2, *$3); }
	 ;
	
call_args : /*blank*/  { $$ = new std::vector<NExpression*>(); }
		  | expr { $$ = new std::vector<NExpression*>(); $$->push_back($1); }
		  | call_args TCOMMA expr  { $1->push_back($3); }
		  ;

comparison : TCEQ | TCNE | TCLT | TCLE | TCGT | TCGE;

%%

void debug(char *msg, Node* node) 
{
	std::cout << msg << " :: " << typeid(*node).name() << std::endl;
}

void yyerror(const char *s)
{
	printf("ERROR: %s\n", s);
}

int yywrap() { }
