TEXT _SYSR1(SB), 1, $0
MOVW R0, 0(FP)
MOVW $0, R0
SWI 0
RET
