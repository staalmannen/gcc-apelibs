TEXT _SEGFREE(SB), 1, $0
MOVW R1, 0(FP)
MOVW $32, R1
SYSCALL
RET