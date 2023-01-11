# my_toy_compiler

Source code for "My Toy Compiler". Read about how I did on my blog:

http://gnuu.org/2009/09/18/writing-your-own-toy-compiler


## llvm 15 compatibility

## run 
./parser example.txt

## debug

lldb ./parser
breakpoint set --file codegen.cpp --line 80
run example.txt
