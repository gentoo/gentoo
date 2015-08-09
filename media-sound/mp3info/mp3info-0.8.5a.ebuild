# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="An MP3 technical info viewer and ID3 1.x tag editor"
HOMEPAGE="http://ibiblio.org/mp3info/"
SRC_URI="http://ibiblio.org/pub/linux/apps/sound/mp3-utils/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="gtk"

RDEPEND="
	gtk? ( >=x11-libs/gtk+-2.6.10:2 )
	sys-libs/ncurses
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-tinfo.patch
	tc-export PKG_CONFIG
}

src_compile() {
	emake mp3info $(usex gtk gmp3info '') CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin mp3info $(usex gtk gmp3info '')

	dodoc ChangeLog README
	doman mp3info.1
}
