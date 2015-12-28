# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit savedconfig toolchain-funcs

DESCRIPTION="Simple plaintext presentation tool"
HOMEPAGE="http://tools.suckless.org/sent/"
SRC_URI="http://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/fontconfig
	media-libs/libpng:*
	x11-libs/libX11
	x11-libs/libXft
"

DEPEND="
	${RDEPEND}

"

src_prepare() {
	sed -i \
		-e 's|^ @|  |g' \
		-e 's|@${CC}|$(CC)|g' \
		-e '/^  echo/d' \
		Makefile || die

	restore_config config.def.h
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
