TEXT _SLEEP(SB), 1, $0
MOVW R0, 0(FP)
MOVW $17, R0
SWI 0
RET
