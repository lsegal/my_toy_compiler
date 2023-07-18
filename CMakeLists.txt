cmake_minimum_required(VERSION 3.1)
project(parser)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

execute_process(COMMAND llvm-config --cppflags
                OUTPUT_VARIABLE llvm_cppflags
                OUTPUT_STRIP_TRAILING_WHITESPACE
                ERROR_STRIP_TRAILING_WHITESPACE)

execute_process(COMMAND llvm-config --libfiles all
                OUTPUT_VARIABLE llvm_libraries
                OUTPUT_STRIP_TRAILING_WHITESPACE
                ERROR_STRIP_TRAILING_WHITESPACE)

execute_process(COMMAND llvm-config --includedir all
                OUTPUT_VARIABLE llvm_includes
                OUTPUT_STRIP_TRAILING_WHITESPACE
                ERROR_STRIP_TRAILING_WHITESPACE)

#SET(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} ${GCC_COVERAGE_COMPILE_FLAGS} ${llvm_cppflags}")

set(sources 
    src/codegen.cpp
    src/corefn.cpp
    src/main.cpp
    src/native.cpp
)

flex_target(
    lexer
    src/tokens.l
    "${CMAKE_CURRENT_BINARY_DIR}/src/tokens.cc"
)
bison_target(
    parser
    src/parser.y
    "${CMAKE_CURRENT_BINARY_DIR}/src/parser.cc"
)

add_executable(parser
    ${sources}
    "${CMAKE_CURRENT_BINARY_DIR}/src/tokens.cc"
    "${CMAKE_CURRENT_BINARY_DIR}/src/parser.cc"
)
include_directories(src)
target_include_directories(parser PRIVATE ${llvm_includes} src/)
target_link_libraries(parser 
    ${llvm_libraries}
)
target_compile_options(parser PRIVATE ${llvm_cppflags})

