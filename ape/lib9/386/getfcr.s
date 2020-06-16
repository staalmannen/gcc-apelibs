.globl	setfcr
setfcr:
	movl		0(%esp),%eax
	xorb		$0x3f,%al
	pushw	%ax
	wait
	fldcw	0(%esp)
	popw	%ax
	ret

.globl	getfcr
getfcr:
	pushw	%ax
	wait
	fstcw	0(%esp)
	popw	%ax
	xorb	$0x3f,%al
	ret

.globl	getfsr
getfsr:
	wait
	fstsw	%ax
	ret

.globl	setfsr
setfsr:
	wait
	fclex
	ret
