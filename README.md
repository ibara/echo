echo
====
echo is a reimplementation of the echo(1) utility without libc.
It is used to teach how argc and argv are passed in Unix.

Why?
----
Read my
[blog post](https://briancallahan.net/blog/20200808.html)
about this codebase.

There is also a
[follow-up blog post](https://briancallahan.net/blog/20200812.html)
about this codebase.

Building
--------
Just run `make`.
This will probably only run on
[OpenBSD](https://www.openbsd.org)/amd64
as is.
Feel free to port to your Unix of choice.

License
-------
ISC License.
See `LICENSE` for details.
