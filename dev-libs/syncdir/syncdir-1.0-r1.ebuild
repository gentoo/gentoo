# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/syncdir/syncdir-1.0-r1.ebuild,v 1.5 2012/12/01 19:50:24 armin76 Exp $

EAPI=4

inherit multilib toolchain-funcs

DESCRIPTION="Provides an alternate implementation for open, link, rename, and unlink"
HOMEPAGE="http://untroubled.org/syncdir"
SRC_URI="http://untroubled.org/syncdir/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE="static-libs"

src_prepare() {
	if ! use static-libs; then
		sed -i Makefile \
			-e '/^all:/s|libsyncdir.a||' \
			-e '/install -m 644 libsyncdir.a/d' \
			|| die "sed Makefile"
	fi
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		libsyncdir.so \
		$(use static-libs && echo libsyncdir.a)
}

src_install() {
	dodir /usr/$(get_libdir)
	emake libdir="${D}/usr/$(get_libdir)" install
	dodoc testsync.c
}
