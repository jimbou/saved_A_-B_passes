#!/bin/bash

rm -r build
mkdir build
cd build
cmake ..
make
cd ..

#clang -S -emit-llvm -Xclang -disable-O0-optnone $1.c
#llvm-as $1.ll -o $1.bc


clang -emit-llvm -c $1.c 
opt -load build/skeleton/libSkeletonPass.* -skeleton < $1.bc > $1_inst.bc 2> code_IR_$1.txt

llc -filetype=obj $1_inst.bc
gcc -o $1 $1_inst.o -O0
chmod +x $1
objdump -d $1 >> code_assembly_$1.txt
./$1 >> run_results_$1.txt