# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic toolchain-funcs prefix

DESCRIPTION="Mail delivery agent/filter"
HOMEPAGE="http://www.procmail.org/"
SRC_URI="http://www.procmail.org/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x64-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"
IUSE="mbox selinux"

DEPEND="virtual/mta"
RDEPEND="selinux? ( sec-policy/selinux-procmail )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# disable flock, using both fcntl and flock style locking
	# doesn't work with NFS with 2.6.17+ kernels, bug #156493

	sed -e "s:/\*#define NO_flock_LOCK:#define NO_flock_LOCK:" \
		-i config.h || die "sed failed"

	if ! use mbox ; then
		echo "# Use maildir-style mailbox in user's home directory" > "${S}"/procmailrc
		echo 'DEFAULT=$HOME/.maildir/' >> "${S}"/procmailrc
		cd "${S}"
		epatch "${FILESDIR}/gentoo-maildir3.diff"
	else
		echo '# Use mbox-style mailbox in /var/spool/mail' > "${S}"/procmailrc
		echo 'DEFAULT=${EPREFIX}/var/spool/mail/$LOGNAME' >> "${S}"/procmailrc
	fi

	# Do not use lazy bindings on lockfile and procmail
	if [[ ${CHOST} != *-darwin* && ${CHOST} != *-interix* ]]; then
		epatch "${FILESDIR}/${PN}-lazy-bindings.diff"
	fi

	# Fix for bug #102340
	epatch "${FILESDIR}/${PN}-comsat-segfault.diff"

	# Fix for bug #119890
	epatch "${FILESDIR}/${PN}-maxprocs-fix.diff"

	# Prefixify config.h
	epatch "${FILESDIR}"/${PN}-prefix.patch
	eprefixify config.h Makefile src/autoconf src/recommend.c

	# Fix for bug #200006
	epatch "${FILESDIR}/${PN}-pipealloc.diff"

	# Fix for bug #270551
	epatch "${FILESDIR}/${PN}-3.22-glibc-2.10.patch"

	# Fix for x86-interix - doesn't have initgroups
	epatch "${FILESDIR}"/${P}-interix.patch
}

src_compile() {
	# -finline-functions (implied by -O3) leaves strstr() in an infinite loop.
	# To work around this, we append -fno-inline-functions to CFLAGS
	# Since GCC 4.7 we also need -fno-ipa-cp-clone (bug #466552)
	append-flags -fno-inline-functions -fno-ipa-cp-clone

	sed -e "s:CFLAGS0 = -O:CFLAGS0 = ${CFLAGS}:" \
		-e "s:LDFLAGS0= -s:LDFLAGS0 = ${LDFLAGS}:" \
		-e "s:LOCKINGTEST=__defaults__:#LOCKINGTEST=__defaults__:" \
		-e "s:#LOCKINGTEST=/tmp:LOCKINGTEST=/tmp:" \
		-i Makefile || die "sed failed"

	emake CC="$(tc-getCC)" || die
}

src_install() {
	cd "${S}"/new
	insinto /usr/bin
	insopts -m 6755
	doins procmail || die

	doins lockfile || die
	fowners root:mail /usr/bin/lockfile
	fperms 2755 /usr/bin/lockfile

	dobin formail mailstat || die
	insopts -m 0644

	doman *.1 *.5

	cd "${S}"
	dodoc FAQ FEATURES HISTORY INSTALL KNOWN_BUGS README

	insinto /etc
	doins procmailrc || die

	docinto examples
	dodoc examples/*
}

pkg_postinst() {
	if ! use mbox ; then
		elog "Starting with mail-filter/procmail-3.22-r9 you'll need to ensure"
		elog "that you configure a mail storage  location using DEFAULT in"
		elog "/etc/procmailrc, for example:"
		elog "\tDEFAULT=\$HOME/.maildir/"
	fi
}
