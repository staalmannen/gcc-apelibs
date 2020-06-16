.globl longjmp
longjmp:
	movl	8(%esp), %eax	/* r */
	cmpl	$0, %eax
	jne	ok		/* ansi: "longjmp(0) => longjmp(1)" */
	movl	$1, %eax		/* bless their pointed heads */
ok:
	movl	4(%esp), %edx		/* l */
	movl	0(%edx), %esp		/* restore sp */
	movl	4(%edx), %ebx		/* put return pc on the stack */
	movl	%ebx, 0(%esp)
	movl	8(%edx), %ebx		/* restore bx */
	movl	12(%edx), %esi		/* restore si */
	movl	16(%edx), %edi		/* restore di */
	movl	20(%edx), %ebp	/* restore bp */
	ret

.globl setjmp
setjmp:
	movl	4(%esp), %edx		/* l */
	movl	%esp, 0(%edx)		/* store sp */
	movl	0(%esp), %eax		/* store return pc */
	movl	%eax, 4(%edx)
	movl	%ebx, 8(%edx)		/* store bx */
	movl	%esi, 12(%edx)		/* store si */
	movl	%edi, 16(%edx)		/* store di */
	movl	%ebp, 20(%edx)	/* store bp */
	movl	$0, %eax			/* return 0 */
	ret

.globl sigsetjmp
sigsetjmp:
	movl	4(%esp), %edx		/* buf */
	movl	8(%esp),%ecx		/* savemask */
	movl	%ecx,0(%edx)
	leal	_psigblocked,%ecx
	movl	%ecx,4(%edx)
	movl	%esp, 8(%edx)		/* store sp */
	movl	0(%esp), %eax		/* store return pc */
	movl	%eax, 12(%edx)
	movl	%ebx, 16(%edx)	/* store bx */
	movl	%esi, 20(%edx)		/* store si */
	movl	%edi, 24(%edx)		/* store di */
	movl	%ebp, 28(%edx)	/* store bp */
	movl	$0, %eax			/* return 0 */
	ret
