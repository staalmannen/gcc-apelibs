TEXT _SEGFLUSH(SB), 1, $0
MOVW R0, 0(FP)
MOVW $33, R0
SWI 0
RET