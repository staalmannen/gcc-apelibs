.globl _mulv
_mulv:
	movl	4(%esp), %ecx
	movl	8(%esp), %eax
	mull	16(%esp)
	movl	%eax, 0(%ecx)
	movl	%edx, %ebx
	movl	8(%esp), %eax
	mull	20(%esp)
	addl	%eax, %ebx
	movl	12(%esp), %eax
	mull	16(%esp)
	addl	%eax, %ebx
	movl	%ebx, 4(%ecx)
	ret

/*
 * _mul64by32(uint64 *r, uint64 a, uint32 b)
 * sets *r = low 64 bits of 96-bit product a*b; returns high 32 bits.
 */
.globl _mul64by32
_mul64by32:
	movl	4(%esp), %ecx
	movl	8(%esp), %eax
	mull	16(%esp)
	movl	%eax, 0(%ecx)	/* *r = low 32 bits of a*b */
	movl	%edx, %ebx		/* %ebx = high 32 bits of a*b */

	movl	12(%esp), %eax
	mull	16(%esp)	/* hi = (a>>32) * b */
	addl	%eax, %ebx		/* %ebx += low 32 bits of hi */
	adcl	$0, %edx		/* %edx = high 32 bits of hi + carry */
	movl	%ebx, 4(%ecx)	/* *r |= (high 32 bits of a*b) << 32 */

	movl	%edx, %eax		/* return hi>>32 */
	ret

.globl _div64by32
_div64by32:
	movl	16(%esp), %ecx
	movl	4(%esp), %eax
	movl	8(%esp), %edx
	divl	12(%esp)
	movl	%edx, 0(%ecx)
	ret

.globl _addv
_addv:
	movl	4(%esp), %ecx
	movl	8(%esp), %eax
	movl	12(%esp), %ebx
	addl	16(%esp), %eax
	adcl	20(%esp), %ebx
	movl	%eax, 0(%ecx)
	movl	%ebx, 4(%ecx)
	ret
