all: parser

OBJS = parser.o  \
       corefn.o  \
       codegen.o \
       main.o    \
       tokens.o  \

CPPFLAGS = `llvm-config --cppflags`
LDFLAGS = `llvm-config --ldflags`
LIBS = `llvm-config --libs` -lz -ldl -pthread -lcurses

clean:
	$(RM) -rf parser.cpp parser.hpp parser tokens.cpp $(OBJS)

parser.cpp: parser.y
	bison -d -o $@ $^
	
parser.hpp: parser.cpp

tokens.cpp: tokens.l parser.hpp
	flex -o $@ $^

%.o: %.cpp
	clang++ -std=c++11 -c $(CPPFLAGS) -o $@ $<


parser: $(OBJS)
	clang++  -std=c++11 -o $@ $(OBJS) $(LIBS) $(LDFLAGS)


