TEXT _FSESSION(SB), 1, $0
MOVW R0, 0(FP)
MOVW $9, R0
SWI 0
RET
