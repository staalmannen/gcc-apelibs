.globl tas
tas:
	pushl	%ebx
	movl		$0xdeadead,%eax
	movl		8(%esp),%ebx
	xchgl	%eax,(%ebx)
	popl		%ebx
	ret
