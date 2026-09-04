# The R5900 (PlayStation 2) FPU has CVT.W.S but none of the rounding
# conversions.
# RUN: not llvm-mc -triple=mips64el-unknown-unknown -mcpu=r5900 -target-abi n32 -show-encoding %s 2>&1 | FileCheck %s
# RUN: not llvm-mc -triple=mips64el-unknown-unknown -mcpu=r5900 -target-abi n32 -show-encoding %s 2>&1 | FileCheck %s --check-prefix=ERR
# RUN: llvm-mc -triple=mips64el-unknown-unknown -mcpu=mips3 -target-abi n32 -show-encoding %s 2>&1 | FileCheck %s --check-prefix=MIPS3

  cvt.w.s $f2, $f1     # CHECK: cvt.w.s $f2, $f1 # encoding: [0xa4,0x08,0x00,0x46]
  cvt.s.w $f2, $f1     # CHECK: cvt.s.w $f2, $f1
  trunc.w.s $f2, $f1   # ERR: [[@LINE]]:{{[0-9]+}}: error: instruction requires
                       # MIPS3: trunc.w.s $f2, $f1
  round.w.s $f2, $f1   # ERR: [[@LINE]]:{{[0-9]+}}: error: instruction requires
  ceil.w.s $f2, $f1    # ERR: [[@LINE]]:{{[0-9]+}}: error: instruction requires
  floor.w.s $f2, $f1   # ERR: [[@LINE]]:{{[0-9]+}}: error: instruction requires
