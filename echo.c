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

/*
 * echo -- print out argv
 */

extern void *_syscall(void *n, void *a, void *b, void *c, void *d, void *e);

static void
write(int d, const void *buf, unsigned long nbytes)
{

	_syscall((void *) 4, (void *) d, (void *) buf, (void *) nbytes, (void *) 0, (void *) 0);
}

static unsigned long
strlen(const char *s)
{
	char *t;

	t = (char *) s;
	while (*t != '\0')
		t++;

	return t - s;
}

int
main(int argc, char *argv[])
{
	int i;

	for (i = 1; i < argc; i++) {
		write(1, argv[i], strlen(argv[i]));
		if (i + 1 != argc)
			write(1, " ", 1);
	}
	write(1, "\n", 1);

	return 0;
}
