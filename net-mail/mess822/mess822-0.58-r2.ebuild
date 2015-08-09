# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit multilib toolchain-funcs eutils

DESCRIPTION="Collection of utilities for parsing Internet mail messages"
SRC_URI="http://cr.yp.to/software/${P}.tar.gz"
HOMEPAGE="http://cr.yp.to/mess822.html"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
LICENSE="public-domain"

RDEPEND=">=sys-apps/sed-4"
DEPEND="${RDEPEND}"
RESTRICT="test"

src_prepare() {
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
	echo "/usr" > conf-home

	# fix errno.h problem; bug #26165
	sed -i 's/^extern int errno;/#include <errno.h>/' error.h

	epatch "${FILESDIR}"/${P}-implicit.patch
}

src_install() {
	dodir /etc
	dodir /usr/share

	# Now that the commands are compiled, update the conf-home file to point
	# to the installation image directory.
	echo "${D}/usr/" > conf-home
	sed -i -e "s:\"/etc\":\"${D}/etc\":" hier.c || die "sed hier.c failed"

	emake setup

	# Move the man pages into /usr/share/man
	mv "${D}/usr/man" "${D}/usr/share/"

	dodir /usr/$(get_libdir)
	mv "${D}/usr/lib/${PN}.a" "${D}/usr/$(get_libdir)/${PN}.a"
	rmdir "${D}/usr/lib"
	dodoc BLURB CHANGES INSTALL README THANKS TODO VERSION
}
