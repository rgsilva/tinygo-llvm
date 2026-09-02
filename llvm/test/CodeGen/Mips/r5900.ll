; The R5900 (PlayStation 2) lacks DMULT/DMULTU/DDIV/DDIVU, LL/SC and LDC1/SDC1.
; Of MIPS-IV it only has the GPR conditional moves MOVN/MOVZ.
; RUN: llc -mtriple=mips64el-unknown-unknown -mcpu=r5900 -target-abi n32 < %s | FileCheck %s
; RUN: llc -mtriple=mips64el-unknown-unknown -mcpu=mips3 -target-abi n32 < %s | FileCheck %s --check-prefix=MIPS3

define i64 @mul64(i64 %a, i64 %b) {
; CHECK-LABEL: mul64:
; CHECK: jal __muldi3
; CHECK-NOT: dmult
; MIPS3-LABEL: mul64:
; MIPS3: dmult
  %r = mul i64 %a, %b
  ret i64 %r
}

define i64 @sdiv64(i64 %a, i64 %b) {
; CHECK-LABEL: sdiv64:
; CHECK: jal __divdi3
; CHECK-NOT: ddiv
; MIPS3-LABEL: sdiv64:
; MIPS3: ddiv
  %r = sdiv i64 %a, %b
  ret i64 %r
}

define i64 @urem64(i64 %a, i64 %b) {
; CHECK-LABEL: urem64:
; CHECK: jal __umoddi3
; CHECK-NOT: ddivu
; MIPS3-LABEL: urem64:
; MIPS3: ddivu
  %r = urem i64 %a, %b
  ret i64 %r
}

define i32 @atomic_add(ptr %p, i32 %v) {
; CHECK-LABEL: atomic_add:
; CHECK: jal __atomic_fetch_add_4
; CHECK-NOT: ll
; CHECK-NOT: sc
; MIPS3-LABEL: atomic_add:
; MIPS3: ll
; MIPS3: sc
  %r = atomicrmw add ptr %p, i32 %v seq_cst
  ret i32 %r
}

define void @copy_double(ptr %dst, ptr %src) {
; CHECK-LABEL: copy_double:
; CHECK-NOT: ldc1
; CHECK-NOT: sdc1
; MIPS3-LABEL: copy_double:
; MIPS3: ldc1
; MIPS3: sdc1
  %v = load double, ptr %src
  store double %v, ptr %dst
  ret void
}

define i32 @select_int(i32 %c, i32 %a, i32 %b) {
; CHECK-LABEL: select_int:
; CHECK: movn
; CHECK-NOT: bnez
; MIPS3-LABEL: select_int:
; MIPS3-NOT: movn
; MIPS3-NOT: movz
  %t = icmp ne i32 %c, 0
  %r = select i1 %t, i32 %a, i32 %b
  ret i32 %r
}

define float @select_float(i32 %c, float %a, float %b) {
; CHECK-LABEL: select_float:
; CHECK-NOT: movn.s
; CHECK-NOT: movz.s
; CHECK: mov.s
  %t = icmp ne i32 %c, 0
  %r = select i1 %t, float %a, float %b
  ret float %r
}

define i32 @select_fcmp(float %x, float %y, i32 %a, i32 %b) {
; CHECK-LABEL: select_fcmp:
; CHECK-NOT: movt
; CHECK-NOT: movf
; CHECK: bc1
  %t = fcmp olt float %x, %y
  %r = select i1 %t, i32 %a, i32 %b
  ret i32 %r
}
