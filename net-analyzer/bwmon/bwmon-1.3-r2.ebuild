# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Simple ncurses bandwidth monitor"
HOMEPAGE="http://bwmon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

RDEPEND="sys-libs/ncurses"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

SLOT="0"
LICENSE="GPL-2 public-domain"
KEYWORDS="amd64 hppa ppc sparc x86"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-typo-fix.patch \
		"${FILESDIR}"/${P}-overflow.patch \
		"${FILESDIR}"/${P}-tinfo.patch
}

src_compile() {
	emake -C src CC="$(tc-getCC)" PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install () {
	dobin ${PN}
	dodoc README
}
