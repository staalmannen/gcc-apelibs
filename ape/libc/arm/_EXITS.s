TEXT _EXITS(SB), 1, $0
MOVW R0, 0(FP)
MOVW $8, R0
SWI 0
RET
