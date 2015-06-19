# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/queue-fix/queue-fix-1.4-r2.ebuild,v 1.20 2014/04/14 18:48:30 ulm Exp $

inherit eutils toolchain-funcs fixheadtails

DESCRIPTION="Qmail Queue Repair Application with support for big-todo"
HOMEPAGE="http://www.netmeridian.com/e-huss/"
SRC_URI="http://www.netmeridian.com/e-huss/${P}.tar.gz
	mirror://qmail/queue-fix-todo.patch"

LICENSE="all-rights-reserved public-domain" # includes code from qmail
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc s390 sh sparc x86"
RESTRICT="mirror bindist"

PDEPEND="virtual/qmail"

src_unpack() {
	unpack ${P}.tar.gz
	epatch "${DISTDIR}"/queue-fix-todo.patch
	sed -i 's/^extern int errno;/#include <errno.h>/' "${S}"/error.h
	ht_fix_file "${S}"/Makefile*
}

src_compile() {
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
	emake || die
}

src_install () {
	into /var/qmail
	dobin queue-fix || die
	into /usr
	dodoc README CHANGES
}
