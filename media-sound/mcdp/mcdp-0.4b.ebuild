# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mcdp/mcdp-0.4b.ebuild,v 1.4 2012/03/19 19:05:17 armin76 Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="A very small console cd player"
HOMEPAGE="http://www.mcmilk.de/projects/mcdp/"
SRC_URI="http://www.mcmilk.de/projects/mcdp/dl/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.4a-dietlibc-fix.patch" \
		"${FILESDIR}/${PN}-0.4a-makefile.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin mcdp
	doman mcdp.1
	dodoc doc/{AUTHOR,BUGS,CHANGES,README,THANKS,TODO,WISHLIST,profile.sh}
}
