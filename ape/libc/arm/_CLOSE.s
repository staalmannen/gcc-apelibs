TEXT _CLOSE(SB), 1, $0
MOVW R0, 0(FP)
MOVW $4, R0
SWI 0
RET
