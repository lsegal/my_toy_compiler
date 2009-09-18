all: parser

clean:
	rm parser.cpp parser tokens.cpp

parser.cpp: parser.y
	bison -d -o $@ $^
	
parser.hpp: parser.cpp

tokens.cpp: tokens.l parser.hpp
	lex -o $@ $^

parser: parser.cpp codegen.cpp main.cpp tokens.cpp
	g++ -o $@ `llvm-config --libs core jit native --cxxflags --ldflags` *.cpp
