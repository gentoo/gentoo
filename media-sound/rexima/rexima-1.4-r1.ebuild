# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A curses-based interactive mixer which can also be used from the command-line"
HOMEPAGE="http://www.svgalib.org/rus/rexima.html"
SRC_URI="ftp://ftp.ibiblio.org/pub/Linux/apps/sound/mixers/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	tc-export CC

	cat > Makefile <<- _EOF_ || die
		LDLIBS=$($(tc-getPKG_CONFIG) --libs ncurses)
		all: rexima
	_EOF_
}

src_install () {
	dobin rexima

	einstalldocs
	doman rexima.1
}
