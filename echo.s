/*
 * Copyright (c) 2020-2021 Brian Callahan <bcallah@openbsd.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

	.text
	.p2align 2
	.globl	_start
	.type	_start,@function
_start:
	popq	%rbp		# Put argc into %rbp (not %rdi)
	pushq	$1
	popq	%rdi		# Put 1 in %rdi for all write(2) calls
	movl	%edi, %edx	# Put 1 in %rdx for all write(2) calls
	pushq	$4
	popq	%rbx		# Store write(2) syscall number
loop:
	decl	%ebp		# while (--argc)
	jz	done
	addq	$8, %rsp	# ++argv
	movq	(%rsp), %rsi	# Next parameter is the top of the stack
printchar:
	cmpb	$0, (%rsi)	# *argv == '\0' ?
	je	space
	movl	%ebx, %eax	# syscall clobbers %rax
	syscall			# write(1, *argv, 1);
	incq	%rsi		# Next character in string
	jmp	printchar
space:
	cmpl	%edi, %ebp	# argc == 1 ?
	je	done
	movb	$32, (%rsi)
	movl	%ebx, %eax
	syscall			# write(1, " ", 1);
	jmp	loop
done:
	movb	$10, (%rsi)
	movl	%ebx, %eax
	syscall			# write(1, "\n", 1);
	xorl	%edi, %edi	# Return 0 (%rax already set to 1 via syscall)
	syscall
	.size	_start,.-_start
