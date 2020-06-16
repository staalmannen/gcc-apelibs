.globl ainc
ainc:			/* int ainc(int*); */
	movl	4(%esp), %ebx
	movl	$1, %eax
	lock
.byte 0x0f, 0xc1, 0x03 /* XADDL %eax, (%ebx) */
	addl	$1, %eax				/* overflow if -ve or 0 */
	ret

.globl adec
adec:				/* int adec(int*); */
	movl	4(%esp), %ebx
	movl	$-1, %eax
	lock
.byte 0x0f, 0xc1, 0x03 /* XADDL %eax, (%ebx) */
	subl	$1, %eax				/* underflow if -ve */
	ret

/*
 * int cas32(u32int *p, u32int ov, u32int nv);
 * int cas(uint *p, int ov, int nv);
 * int casp(void **p, void *ov, void *nv);
 * int casl(ulong *p, ulong ov, ulong nv);
 */

/*
 * cmpxchg (%ecx), %edx: 0000 1111 1011 000w oorr rmmm,
 * mmm = %ecx = 001; rrr = %edx = 010
 */

.globl	cas32
cas32:
.globl	cas
cas:
.globl	casp
casp:
.globl	casl
casl:
	movl	4(%esp), %ecx
	movl	8(%esp), %eax
	movl	12(%esp), %edx
	lock
.byte 0x0F, 0xB1, 0x11 /* cmpxchg */
	jne	fail
	movl	$1,%eax
	ret
fail:
	movl	$0,%eax
	ret

/*
 * int cas64(u64int *p, u64int ov, u64int nv);
 */

/*
 * cmpxchg64 (%edi): 0000 1111 1100 0111 0000 1110,
 */

.globl	cas64
cas64:
	movl	4(%esp), %edi
	movl	4+0x4(%esp), %eax
	movl	4+0x8(%esp), %edx
	movl	4+0xc(%esp), %ebx
	movl	4+0x10(%esp), %ecx
	lock
.byte 0x0F, 0xC7, 0x0F /* cmpxchg64 */
	jne	fail
	movl	$1,%eax
	ret

/*
 * Versions of compare-and-swap that return the old value
 * (i.e., the value of *p at the time of the operation
 * 	xcas(p, o, n) == o
 * yields the same value as
 *	cas(p, o, n)
 * xcas can be used in constructs like
 *	for(o = *p; (oo = xcas(p, o, o+1)) != o; o = oo)
 *		;
 * to avoid the extra dereference of *p (the example is a silly
 * way to increment *p atomically)
 *
 * u32int	xcas32(u32int *p, u32int ov, u32int nv);
 * u64int	xcas64(u64int *p, u64int ov, u64int nv);
 * int		xcas(int *p, int ov, int nv);
 * void*	xcasp(void **p, void *ov, void *nv);
 * ulong	xcasl(ulong *p, ulong ov, ulong nv);
 */

.globl	xcas32
xcas32:
.globl	xcas
xcas:
.globl	xcasp
xcasp:
.globl	xcasl
xcasl:
	movl	4(%esp), %ecx
	movl	8(%esp), %eax	/* accumulator */
	movl	12(%esp), %edx
	lock
.byte 0x0F, 0xB1, 0x11 /* cmpxchg */
	ret
	
/*
 * The cmpxchg8B instruction also requires three operands:
 * a 64-bit value in %edx:%eax, a 64-bit value in %ecx:%ebx,
 * and a destination operand in memory. The instruction compar
 * es the 64-bit value in the %edx:%eax registers with the
 * destination operand. If they are equal, the 64-bit value
 * in the %ecx:%ebx register is stored in the destination
 * operand. If the %edx:%eax register and the destination ar
 * e not equal, the destination is loaded in the %edx:%eax
 * register. The cmpxchg8B instruction can be combined with
 * the lock prefix to perform the operation atomically
 */
.ret:
	ret

.globl	xcas64
xcas64:
	movl	8(%esp), %edi
	movl	4+0x8(%esp), %eax
	movl	4+0xc(%esp), %edx
	movl	4+0x10(%esp), %ebx
	movl	4+0x14(%esp), %ecx
	lock
.byte 0x0F, 0xB1, 0x11 /* cmpxchg */
	movl	.ret+0x0(%esp),%ecx	/* pointer to return value */
	movl	%eax,0x0(%ecx)
	movl	%edx,0x4(%ecx)
	ret
