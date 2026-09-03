# RUN: llvm-mc %s -triple=mips -mcpu=mips32 | \
# RUN:   FileCheck %s -check-prefix=CHECK-ASM
#
# RUN: llvm-mc %s -triple=mips -mcpu=mips32 -filetype=obj -o - | \
# RUN:   llvm-readobj -A - | \
# RUN:     FileCheck %s -check-prefix=CHECK-OBJ

# CHECK-ASM: .module singlefloat

# Check if the MIPS.abiflags section was correctly emitted:
# CHECK-OBJ: MIPS ABI Flags {
# CHECK-OBJ:   FP ABI: Hard float (single precision) (0x2)
# CHECK-OBJ: }

  .module singlefloat
