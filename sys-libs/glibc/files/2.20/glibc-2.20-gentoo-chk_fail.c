/* Copyright (C) 2004-2014 Free Software Foundation, Inc.
   Copyright (C) 2006-2014 Gentoo Foundation Inc.
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

/* Hardened Gentoo SSP and FORTIFY handler

   A failure handler that does not use functions from the rest of glibc;
   it uses the INTERNAL_SYSCALL methods directly.  This helps ensure no
   possibility of recursion into the handler.

   Direct all bug reports to http://bugs.gentoo.org/

   People who have contributed significantly to the evolution of this file:
   Ned Ludd - <solar[@]gentoo.org>
   Alexander Gabert - <pappy[@]gentoo.org>
   The PaX Team - <pageexec[@]freemail.hu>
   Peter S. Mazinger - <ps.m[@]gmx.net>
   Yoann Vandoorselaere - <yoann[@]prelude-ids.org>
   Robert Connolly - <robert[@]linuxfromscratch.org>
   Cory Visi <cory[@]visi.name>
   Mike Frysinger <vapier[@]gentoo.org>
   Magnus Granberg <zorry[@]gentoo.org>
   Kevin F. Quinn - <kevquinn[@]gentoo.org>
 */

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
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
static const char *__progname = "<ldso>";
#else
extern const char *__progname;
#endif

#ifdef GENTOO_SSP_HANDLER
# define ERROR_MSG "stack smashing"
#else
# define ERROR_MSG "buffer overflow"
#endif

/* Common handler code, used by chk_fail
 * Inlined to ensure no self-references to the handler within itself.
 * Data static to avoid putting more than necessary on the stack,
 * to aid core debugging.
 */
__attribute__ ((__noreturn__, __always_inline__))
static inline void
__hardened_gentoo_fail(void)
{
#define MESSAGE_BUFSIZ 512
	static pid_t pid;
	static int plen, i, hlen;
	static char message[MESSAGE_BUFSIZ];
	/* <11> is LOG_USER|LOG_ERR. A dummy date for loggers to skip over. */
	static const char msg_header[] = "<11>" __DATE__ " " __TIME__ " glibc-gentoo-hardened-check: ";
	static const char msg_ssd[] = "*** " ERROR_MSG " detected ***: ";
	static const char msg_terminated[] = " terminated; ";
	static const char msg_report[] = "report to " REPORT_BUGS_TO "\n";
	static const char msg_unknown[] = "<unknown>";
	static int log_socket, connect_result;
	static struct sockaddr_un sock;
	static unsigned long int socketargs[4];

	/* Build socket address */
	sock.sun_family = AF_UNIX;
	i = 0;
	while (path_log[i] != '\0' && i < sizeof(sock.sun_path) - 1) {
		sock.sun_path[i] = path_log[i];
		++i;
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
	({ \
		i = 0; \
		while ((str[i] != '\0') && ((i + plen) < (MESSAGE_BUFSIZ - 1))) { \
			message[plen + i] = str[i]; \
			++i; \
		} \
		plen += i; \
	})

	/* Tersely log the failure */
	plen = 0;
	strconcat(msg_header);
	hlen = plen;
	strconcat(msg_ssd);
	if (__progname != NULL)
		strconcat(__progname);
	else
		strconcat(msg_unknown);
	strconcat(msg_terminated);
	strconcat(msg_report);

	/* Write out error message to STDERR, to syslog if open */
	INLINE_SYSCALL(write, 3, STDERR_FILENO, message + hlen, plen - hlen);
	if (connect_result != -1) {
		INLINE_SYSCALL(write, 3, log_socket, message, plen);
		INLINE_SYSCALL(close, 1, log_socket);
	}

	/* Time to kill self since we have no idea what is going on */
	pid = INLINE_SYSCALL(getpid, 0);

	if (ENABLE_SSP_SMASH_DUMPS_CORE) {
		/* Remove any user-supplied handler for SIGABRT, before using it. */
#if 0
		/*
		 * Note: Disabled because some programs catch & process their
		 * own crashes.  We've already enabled this code path which
		 * means we want to let core dumps happen.
		 */
		static struct sigaction default_abort_act;
		default_abort_act.sa_handler = SIG_DFL;
		default_abort_act.sa_sigaction = NULL;
		__sigfillset(&default_abort_act.sa_mask);
		default_abort_act.sa_flags = 0;
		if (DO_SIGACTION(SIGABRT, &default_abort_act, NULL) == 0)
#endif
			INLINE_SYSCALL(kill, 2, pid, SIGABRT);
	}

	/* SIGKILL is only signal which cannot be caught */
	INLINE_SYSCALL(kill, 2, pid, SIGKILL);

	/* In case the kill didn't work, exit anyway.
	 * The loop prevents gcc thinking this routine returns.
	 */
	while (1)
		INLINE_SYSCALL(exit, 1, 137);
}

__attribute__ ((__noreturn__))
#ifdef GENTOO_SSP_HANDLER
void __stack_chk_fail(void)
#else
void __chk_fail(void)
#endif
{
	__hardened_gentoo_fail();
}
