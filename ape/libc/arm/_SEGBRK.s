TEXT _SEGBRK(SB), 1, $0
MOVW R0, 0(FP)
MOVW $12, R0
SWI 0
RET
