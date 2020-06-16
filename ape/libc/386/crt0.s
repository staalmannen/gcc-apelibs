.globl	_main
_main:
	subl $12, %esp
	call	_envsetup
	movl	12(%esp), %eax
	movl	%eax, 0(%esp)
	leal	16(%esp), %eax
	movl	%eax, 4(%esp)
	movl	environ, %eax
	movl	%eax, 8(%esp)
	call	main
	movl	%eax, 0(%esp)
	call	exit
	ret
