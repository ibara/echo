# echo Makefile

CC =		cc
CFLAGS =	-Oz -nostdinc -fomit-frame-pointer
CFLAGS +=	-fno-PIE -fno-PIC -fno-ret-protector
CFLAGS +=	-fno-stack-protector -mno-retpoline
CFLAGS +=	-fno-asynchronous-unwind-tables
CFLAGS +=	-Wno-int-to-void-pointer-cast

PROG =	echo
OBJS =	_start.o _syscall.o crt.o echo.o

all: ${OBJS}
	/usr/bin/ld -nostdlib -nopie -o ${PROG} ${OBJS}
	/usr/bin/strip ${PROG}
	/usr/bin/strip -R .comment ${PROG}

asm: _start.o _syscall.o crt.o
	/usr/bin/as -o echo.o echo.s
	/usr/bin/ld -nostdlib -nopie -o ${PROG} ${OBJS}
	/usr/bin/strip ${PROG}
	/usr/bin/strip -R .bss ${PROG}
	/usr/bin/strip -R .comment ${PROG}
	/usr/bin/strip -R .data ${PROG}

clean:
	rm -rf ${PROG} ${OBJS} ${PROG}.core ${PROG}~
