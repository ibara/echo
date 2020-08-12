/*
 * Copyright (c) 2020 Brian Callahan <bcallah@openbsd.org>
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
	.globl	main
main:
	movq	%rdi, %r15	# Get argc from %rdi, put it in %r15
	movq	%rsi, %r14	# Get argv from %rsi, put it in %r14
	movq	%rsi, %r13	# A temporary memory location
loop:
	decl	%r15d		# 47: for (i = 0; i < argc; i++) {
	jz	done		# Rewritten as: while (--argc) {
	movl	$4, %eax	# Set up write(2)
	movl	$1, %edi	# First parameter is 1
	movq	8(%r14), %rsi	# Second parameter is *argv
	addq	$8, %r14	# ++argv
	leaq	-1(%rsi), %rdx	# Get *argv[0]
strlen:				# Note: strlen has been inlined
	cmpb	$0, 1(%rdx)	# 36: while (*t != '\0')
	leaq	1(%rdx), %rdx	# 37: t++;
	jne	strlen
	subq	%rsi, %rdx	# 39: return t - s;
	syscall			# 48: write(1, *argv, %rdx);
	cmpl	$1, %r15d	# 49: if (i + 1 != argc)
	je	done		# Rewritten as: if (argc != 1)
	movl	$4, %eax	# Set up write(2)
	movl	$1, %edi	# First parameter is 1
	movq	%r13, %rsi	# Set %rsi to temporary memory location
	movl	$32, (%rsi)	# Second parameter is " "
	movl	$1, %edx	# Third parameter is 1
	syscall			# 50: write(1, " ", 1);
	jmp	loop
done:
	movl	$4, %eax	# Set up write(2)
	movl	$1, %edi	# First parameter is 1
	movq	%r13, %rsi	# Set %rsi to temporary memory location
	movl	$10, (%rsi)	# Second parameter is "\n"
	movl	$1, %edx	# Third parameter is 1
	syscall			# 52: write(1, "\n", 1);
	xorl	%eax, %eax	# Return value is 0
	retq			# 54: return 0;
	.size	main,.-main
