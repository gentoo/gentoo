# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/canfep/canfep-1.0.ebuild,v 1.8 2013/04/17 18:43:38 ulm Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Canna Japanese kana-kanji frontend processor on console"
HOMEPAGE="http://www.geocities.co.jp/SiliconValley-Bay/7584/canfep/"
SRC_URI="http://www.geocities.co.jp/SiliconValley-Bay/7584/canfep/${P}.tar.gz
	unicode? ( http://hp.vector.co.jp/authors/VA020411/patches/canfep_utf8.diff )"

LICENSE="canfep"
SLOT="0"
KEYWORDS="-alpha ~amd64 ppc ~sparc x86"
IUSE="unicode"

DEPEND="app-i18n/canna
	sys-libs/ncurses"
RDEPEND="app-i18n/canna"

src_prepare() {
	use unicode && epatch "${DISTDIR}"/canfep_utf8.diff
	sed -i "s:\$(CFLAGS):\$(CFLAGS) \$(LDFLAGS):" Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		LIBS="-lcanna -lncurses"
}

src_install() {
	dobin canfep
	dodoc 00changes 00readme
}
