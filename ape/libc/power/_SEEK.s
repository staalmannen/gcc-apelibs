TEXT _SEEK(SB), 1, $0
MOVW R3, 0(FP)
MOVW $39, R3
SYSCALL
CMP R3,$-1
BNE 4(PC)
MOVW a+0(FP),R8
MOVW R3,0(R8)
MOVW R3,4(R8)
RETURN