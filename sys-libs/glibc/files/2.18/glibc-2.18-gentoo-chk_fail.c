/* Copyright (C) 2004, 2005 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

/* Copyright (C) 2006-2013 Gentoo Foundation Inc.
 * License terms as above.
 *
 * Hardened Gentoo SSP and FORTIFY handler
 *
 * An SSP failure handler that does not use functions from the rest of
 * glibc; it uses the INTERNAL_SYSCALL methods directly.  This ensures
 * no possibility of recursion into the handler.
 *
 * Direct all bug reports to http://bugs.gentoo.org/
 *
 * Re-written from the glibc-2.3 Hardened Gentoo SSP handler
 * by Kevin F. Quinn - <kevquinn[@]gentoo.org>
 *
 * The following people contributed to the glibc-2.3 Hardened
 * Gentoo SSP and FORTIFY handler, from which this implementation draws much:
 *
 * Ned Ludd - <solar[@]gentoo.org>
 * Alexander Gabert - <pappy[@]gentoo.org>
 * The PaX Team - <pageexec[@]freemail.hu>
 * Peter S. Mazinger - <ps.m[@]gmx.net>
 * Yoann Vandoorselaere - <yoann[@]prelude-ids.org>
 * Robert Connolly - <robert[@]linuxfromscratch.org>
 * Cory Visi <cory[@]visi.name>
 * Mike Frysinger <vapier[@]gentoo.org>
 * Magnus Granberg <zorry[@]ume.nu>
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <signal.h>

#include <sys/types.h>

#include <sysdep-cancel.h>
#include <sys/syscall.h>

#include <kernel-features.h>

#include <alloca.h>
/* from sysdeps */
#include <socketcall.h>
/* for the stuff in bits/socket.h */
#include <sys/socket.h>
#include <sys/un.h>

/* Sanity check on SYSCALL macro names - force compilation
 * failure if the names used here do not exist
 */
#if !defined __NR_socketcall && !defined __NR_socket
# error Cannot do syscall socket or socketcall
#endif
#if !defined __NR_socketcall && !defined __NR_connect
# error Cannot do syscall connect or socketcall
#endif
#ifndef __NR_write
# error Cannot do syscall write
#endif
#ifndef __NR_close
# error Cannot do syscall close
#endif
#ifndef __NR_getpid
# error Cannot do syscall getpid
#endif
#ifndef __NR_kill
# error Cannot do syscall kill
#endif
#ifndef __NR_exit
# error Cannot do syscall exit
#endif
#ifdef SSP_SMASH_DUMPS_CORE
# define ENABLE_SSP_SMASH_DUMPS_CORE 1
# if !defined _KERNEL_NSIG && !defined _NSIG
#  error No _NSIG or _KERNEL_NSIG for rt_sigaction
# endif
# if !defined __NR_sigaction && !defined __NR_rt_sigaction
#  error Cannot do syscall sigaction or rt_sigaction
# endif
/* Although rt_sigaction expects sizeof(sigset_t) - it expects the size
 * of the _kernel_ sigset_t which is not the same as the user sigset_t.
 * Most arches have this as _NSIG bits - mips has _KERNEL_NSIG bits for
 * some reason.
 */
# ifdef _KERNEL_NSIG
#  define _SSP_NSIG _KERNEL_NSIG
# else
#  define _SSP_NSIG _NSIG
# endif
#else
# define _SSP_NSIG 0
# define ENABLE_SSP_SMASH_DUMPS_CORE 0
#endif

/* Define DO_SIGACTION - default to newer rt signal interface but
 * fallback to old as needed.
 */
#ifdef __NR_rt_sigaction
# define DO_SIGACTION(signum, act, oldact) \
	INLINE_SYSCALL(rt_sigaction, 4, signum, act, oldact, _SSP_NSIG/8)
#else
# define DO_SIGACTION(signum, act, oldact) \
	INLINE_SYSCALL(sigaction, 3, signum, act, oldact)
#endif

/* Define DO_SOCKET/DO_CONNECT functions to deal with socketcall vs socket/connect */
#if defined(__NR_socket) && defined(__NR_connect)
# define USE_OLD_SOCKETCALL 0
#else
# define USE_OLD_SOCKETCALL 1
#endif

/* stub out the __NR_'s so we can let gcc optimize away dead code */
#ifndef __NR_socketcall
# define __NR_socketcall 0
#endif
#ifndef __NR_socket
# define __NR_socket 0
#endif
#ifndef __NR_connect
# define __NR_connect 0
#endif
#define DO_SOCKET(result, domain, type, protocol) \
	do { \
		if (USE_OLD_SOCKETCALL) { \
			socketargs[0] = domain; \
			socketargs[1] = type; \
			socketargs[2] = protocol; \
			socketargs[3] = 0; \
			result = INLINE_SYSCALL(socketcall, 2, SOCKOP_socket, socketargs); \
		} else \
			result = INLINE_SYSCALL(socket, 3, domain, type, protocol); \
	} while (0)
#define DO_CONNECT(result, sockfd, serv_addr, addrlen) \
	do { \
		if (USE_OLD_SOCKETCALL) { \
			socketargs[0] = sockfd; \
			socketargs[1] = (unsigned long int)serv_addr; \
			socketargs[2] = addrlen; \
			socketargs[3] = 0; \
			result = INLINE_SYSCALL(socketcall, 2, SOCKOP_connect, socketargs); \
		} else \
			result = INLINE_SYSCALL(connect, 3, sockfd, serv_addr, addrlen); \
	} while (0)

#ifndef _PATH_LOG
# define _PATH_LOG "/dev/log"
#endif

static const char path_log[] = _PATH_LOG;

/* For building glibc with SSP switched on, define __progname to a
 * constant if building for the run-time loader, to avoid pulling
 * in more of libc.so into ld.so
 */
#ifdef IS_IN_rtld
static char *__progname = "<rtld>";
#else
extern char *__progname;
#endif

/* Common handler code, used by chk_fail
 * Inlined to ensure no self-references to the handler within itself.
 * Data static to avoid putting more than necessary on the stack,
 * to aid core debugging.
 */
__attribute__ ((__noreturn__ , __always_inline__))
static inline void
__hardened_gentoo_chk_fail(char func[], int damaged)
{
#define MESSAGE_BUFSIZ 256
	static pid_t pid;
	static int plen, i;
	static char message[MESSAGE_BUFSIZ];
	static const char msg_ssa[] = ": buffer overflow attack";
	static const char msg_inf[] = " in function ";
	static const char msg_ssd[] = "*** buffer overflow detected ***: ";
	static const char msg_terminated[] = " - terminated\n";
	static const char msg_report[] = "Report to http://bugs.gentoo.org/\n";
	static const char msg_unknown[] = "<unknown>";
	static int log_socket, connect_result;
	static struct sockaddr_un sock;
	static unsigned long int socketargs[4];

	/* Build socket address
	 */
	sock.sun_family = AF_UNIX;
	i = 0;
	while ((path_log[i] != '\0') && (i<(sizeof(sock.sun_path)-1))) {
		sock.sun_path[i] = path_log[i];
		i++;
	}
	sock.sun_path[i] = '\0';

	/* Try SOCK_DGRAM connection to syslog */
	connect_result = -1;
	DO_SOCKET(log_socket, AF_UNIX, SOCK_DGRAM, 0);
	if (log_socket != -1)
		DO_CONNECT(connect_result, log_socket, &sock, sizeof(sock));
	if (connect_result == -1) {
		if (log_socket != -1)
			INLINE_SYSCALL(close, 1, log_socket);
		/* Try SOCK_STREAM connection to syslog */
		DO_SOCKET(log_socket, AF_UNIX, SOCK_STREAM, 0);
		if (log_socket != -1)
			DO_CONNECT(connect_result, log_socket, &sock, sizeof(sock));
	}

	/* Build message.  Messages are generated both in the old style and new style,
	 * so that log watchers that are configured for the old-style message continue
	 * to work.
	 */
#define strconcat(str) \
		{i=0; while ((str[i] != '\0') && ((i+plen)<(MESSAGE_BUFSIZ-1))) \
		{\
			message[plen+i]=str[i];\
			i++;\
		}\
		plen+=i;}

	/* R.Henderson post-gcc-4 style message */
	plen = 0;
	strconcat(msg_ssd);
	if (__progname != (char *)0)
		strconcat(__progname)
	else
		strconcat(msg_unknown);
	strconcat(msg_terminated);

	/* Write out error message to STDERR, to syslog if open */
	INLINE_SYSCALL(write, 3, STDERR_FILENO, message, plen);
	if (connect_result != -1)
		INLINE_SYSCALL(write, 3, log_socket, message, plen);

	/* Dr. Etoh pre-gcc-4 style message */
	plen = 0;
	if (__progname != (char *)0)
		strconcat(__progname)
	else
		strconcat(msg_unknown);
	strconcat(msg_ssa);
	strconcat(msg_inf);
	if (func != NULL)
		strconcat(func)
	else
		strconcat(msg_unknown);
	strconcat(msg_terminated);
	/* Write out error message to STDERR, to syslog if open */
	INLINE_SYSCALL(write, 3, STDERR_FILENO, message, plen);
	if (connect_result != -1)
		INLINE_SYSCALL(write, 3, log_socket, message, plen);

	/* Direct reports to bugs.gentoo.org */
	plen=0;
	strconcat(msg_report);
	message[plen++]='\0';

	/* Write out error message to STDERR, to syslog if open */
	INLINE_SYSCALL(write, 3, STDERR_FILENO, message, plen);
	if (connect_result != -1)
		INLINE_SYSCALL(write, 3, log_socket, message, plen);

	if (log_socket != -1)
		INLINE_SYSCALL(close, 1, log_socket);

	/* Suicide */
	pid = INLINE_SYSCALL(getpid, 0);

	if (ENABLE_SSP_SMASH_DUMPS_CORE) {
		static struct sigaction default_abort_act;
		/* Remove any user-supplied handler for SIGABRT, before using it */
		default_abort_act.sa_handler = SIG_DFL;
		default_abort_act.sa_sigaction = NULL;
		__sigfillset(&default_abort_act.sa_mask);
		default_abort_act.sa_flags = 0;
		if (DO_SIGACTION(SIGABRT, &default_abort_act, NULL) == 0)
			INLINE_SYSCALL(kill, 2, pid, SIGABRT);
	}

	/* Note; actions cannot be added to SIGKILL */
	INLINE_SYSCALL(kill, 2, pid, SIGKILL);

	/* In case the kill didn't work, exit anyway
	 * The loop prevents gcc thinking this routine returns
	 */
	while (1)
		INLINE_SYSCALL(exit, 0);
}

__attribute__ ((__noreturn__))
void __chk_fail(void)
{
	__hardened_gentoo_chk_fail(NULL, 0);
}

