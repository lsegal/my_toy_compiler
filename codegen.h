#include <stack>
#include <llvm/Module.h>
#include <llvm/Function.h>
#include <llvm/PassManager.h>
#include <llvm/CallingConv.h>
#include <llvm/Bitcode/ReaderWriter.h>
#include <llvm/Analysis/Verifier.h>
#include <llvm/Assembly/PrintModulePass.h>
#include <llvm/Support/IRBuilder.h>
#include <llvm/ModuleProvider.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include <llvm/ExecutionEngine/JIT.h>
#include <llvm/Support/raw_ostream.h>

using namespace llvm;

class NBlock;

class CodeGenBlock {
public:
    BasicBlock *block;
    std::map<std::string, Value*> locals;
};

class CodeGenContext {
    std::stack<CodeGenBlock *> blocks;
    Function *mainFunction;

public:
	Value *cObject;
    Module *module;
	Function *objallocFunction;
	Function *putSlotFunction;
	Function *getSlotFunction;
	Function *newobjFunction;
    CodeGenContext() { module = new Module("main"); }
    
	const StructType* addStructType(char *name, size_t numArgs, ...);
	FunctionType* functionType(const Type* retType, bool varargs, size_t numArgs, ...);
	Function* addExternalFunction(char *name, FunctionType *ftype);
	Function *addFunction(char *name, FunctionType *ftype, void (^block)(BasicBlock *));
    void generateCode(NBlock& root);
    GenericValue runCode();
    std::map<std::string, Value*>& locals() { return blocks.top()->locals; }
    BasicBlock *currentBlock() { return blocks.top()->block; }
    void pushBlock(BasicBlock *block) { blocks.push(new CodeGenBlock()); blocks.top()->block = block; }
    void popBlock() { CodeGenBlock *top = blocks.top(); blocks.pop(); delete top; }
};
