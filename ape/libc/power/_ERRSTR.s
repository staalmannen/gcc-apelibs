TEXT _ERRSTR(SB), 1, $0
MOVW R3, 0(FP)
MOVW $1, R3
SYSCALL
RETURN
