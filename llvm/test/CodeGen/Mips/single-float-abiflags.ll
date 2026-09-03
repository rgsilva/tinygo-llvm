; -msingle-float must be recorded in .MIPS.abiflags (as GCC does), on every ABI.
; RUN: llc -mtriple=mipsel-unknown-unknown -mattr=+single-float < %s | FileCheck %s --check-prefix=ASM
; RUN: llc -mtriple=mips64el-unknown-unknown -target-abi n32 -mattr=+single-float -filetype=obj < %s | llvm-readobj -A - | FileCheck %s --check-prefix=OBJ
; RUN: llc -mtriple=mipsel-unknown-unknown -mattr=+single-float -filetype=obj < %s | llvm-readobj -A - | FileCheck %s --check-prefix=OBJ
; RUN: llc -mtriple=mips64el-unknown-unknown -target-abi n32 -filetype=obj < %s | llvm-readobj -A - | FileCheck %s --check-prefix=DOUBLE

; The .module directive is only emitted for O32 (N32/N64 have fixed FP ABIs).
; ASM: .module singlefloat
; OBJ: FP ABI: Hard float (single precision) (0x2)
; DOUBLE: FP ABI: Hard float (double precision) (0x1)

define float @f(float %a, float %b) {
  %r = fadd float %a, %b
  ret float %r
}
