TEXT _SEGDETACH(SB), 1, $0
MOVW R7, 0(FP)
MOVW $31, R7
TA R0
RETURN
