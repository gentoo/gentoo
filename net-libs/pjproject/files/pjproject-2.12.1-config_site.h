/*
 * Based off of the Asterisk config_site.h file.
 *
 * In general it's the same with some removals due to being ebuild-managed.
 */

#include <sys/select.h>

#define GENTOO_INVALID	(Gentoo compile failure - please report a bug on bugs.gentoo.org)

/* asterisk_malloc_debug.h is not required ... most of the operations are no-ops regardless
 * and I can't see why asterisk is looking to compile this directly into pjproject */

/*
 * Defining PJMEDIA_HAS_SRTP to 0 does NOT disable Asterisk's ability to use srtp.
 * It only disables the pjmedia srtp transport which Asterisk doesn't use.
 * The reason for the disable is that while Asterisk works fine with older libsrtp
 * versions, newer versions of pjproject won't compile with them.
 *
 * Disabling this depends on an additional pjproject patch.  So just leave it
 * enabled for the time being, as it has always been enabled.
 */
#define PJMEDIA_HAS_SRTP 1

/* Ability to change this has ABI implications, force it on */
/* Can be reconsidered in future:  https://bugs.gentoo.org/680496 */
#define PJ_HAS_IPV6 1

#define PJ_MAX_HOSTNAME (256)
#define PJSIP_MAX_URL_SIZE (512)
#ifdef PJ_HAS_LINUX_EPOLL
#define PJ_IOQUEUE_MAX_HANDLES	(5000)
#else
#define PJ_IOQUEUE_MAX_HANDLES	(FD_SETSIZE)
#endif
#define PJ_IOQUEUE_HAS_SAFE_UNREG 1
#define PJ_IOQUEUE_MAX_EVENTS_IN_SINGLE_POLL (16)

#define PJ_SCANNER_USE_BITWISE	0
#define PJ_OS_HAS_CHECK_STACK	0

#ifndef PJ_LOG_MAX_LEVEL
#define PJ_LOG_MAX_LEVEL		6
#endif

#define PJ_ENABLE_EXTRA_CHECK	1
#define PJSIP_MAX_TSX_COUNT		((64*1024)-1)
#define PJSIP_MAX_DIALOG_COUNT	((64*1024)-1)
#define PJSIP_UDP_SO_SNDBUF_SIZE	(512*1024)
#define PJSIP_UDP_SO_RCVBUF_SIZE	(512*1024)
#define PJ_DEBUG			0
#define PJSIP_SAFE_MODULE		0
#define PJ_HAS_STRICMP_ALNUM		0

/*
 * Do not ever enable PJ_HASH_USE_OWN_TOLOWER because the algorithm is
 * inconsistently used when calculating the hash value and doesn't
 * convert the same characters as pj_tolower()/tolower().  Thus you
 * can get different hash values if the string hashed has certain
 * characters in it.  (ASCII '@', '[', '\\', ']', '^', and '_')
 */
#undef PJ_HASH_USE_OWN_TOLOWER

/*
  It is imperative that PJSIP_UNESCAPE_IN_PLACE remain 0 or undefined.
  Enabling it will result in SEGFAULTS when URIs containing escape sequences are encountered.
*/
#undef PJSIP_UNESCAPE_IN_PLACE
#define PJSIP_MAX_PKT_LEN			65535

#undef PJ_TODO
#define PJ_TODO(x)

/* Defaults too low for WebRTC */
#define PJ_ICE_MAX_CAND 64
#define PJ_ICE_MAX_CHECKS (PJ_ICE_MAX_CAND * PJ_ICE_MAX_CAND)

/* Increase limits to allow more formats */
#define	PJMEDIA_MAX_SDP_FMT   64
#define	PJMEDIA_MAX_SDP_BANDW   4
#define	PJMEDIA_MAX_SDP_ATTR   (PJMEDIA_MAX_SDP_FMT*3 + 4)
#define	PJMEDIA_MAX_SDP_MEDIA   16

/*
 * Turn off the periodic sending of CRLNCRLN.  Default is on (90 seconds),
 * which conflicts with the global section's keep_alive_interval option in
 * pjsip.conf.
 */
#define PJSIP_TCP_KEEP_ALIVE_INTERVAL	0
#define PJSIP_TLS_KEEP_ALIVE_INTERVAL	0

#define PJSIP_TSX_UAS_CONTINUE_ON_TP_ERROR 0
#define PJ_SSL_SOCK_OSSL_USE_THREAD_CB 0
#define PJSIP_AUTH_ALLOW_MULTIPLE_AUTH_HEADER 1

/* Required to enable things like USE=video. */
#define PJMEDIA_HAS_VIDEO GENTOO_INVALID
