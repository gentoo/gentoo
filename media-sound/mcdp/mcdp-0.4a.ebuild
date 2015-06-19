# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mcdp/mcdp-0.4a.ebuild,v 1.6 2012/03/19 19:05:17 armin76 Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A very small console cd player"
HOMEPAGE="http://www.mcmilk.de/projects/mcdp/"
SRC_URI="http://www.mcmilk.de/projects/mcdp/dl/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-dietlibc-fix.patch"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	dobin mcdp || die
	doman mcdp.1 || die

	cd doc
	dodoc AUTHOR BUGS CHANGES README THANKS TODO WISHLIST profile.sh
}
