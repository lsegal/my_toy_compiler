all: parser

clean:
	rm parser.cpp parser.hpp parser tokens.cpp

parser.cpp: parser.y
	bison -d -o $@ $^
	
parser.hpp: parser.cpp

tokens.cpp: tokens.l parser.hpp
	lex -o $@ $^

parser: parser.cpp codegen.cpp main.cpp tokens.cpp slot.cpp
	llvm-g++ -o $@ -DDEBUG `llvm-config --libs core jit native --cxxflags --ldflags` *.cpp
