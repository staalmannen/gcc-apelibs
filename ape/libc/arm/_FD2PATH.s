TEXT _FD2PATH(SB), 1, $0
MOVW R0, 0(FP)
MOVW $23, R0
SWI 0
RET
