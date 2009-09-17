all: parser

clean:
	rm parser.cpp parser tokens.inc

parser.cpp: parser.y
	bison -d -o $@ $^

tokens.inc: tokens.l
	lex -o $@ $^

parser: parser.cpp codegen.cpp main.cpp tokens.inc
	g++ -o $@ `llvm-config --libs core jit native --cxxflags --ldflags` parser.cpp codegen.cpp main.cpp
