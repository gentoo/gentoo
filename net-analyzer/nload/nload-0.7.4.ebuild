# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

DESCRIPTION="Real time network traffic monitor for the command line interface"
HOMEPAGE="http://www.roland-riegel.de/nload/index.html"
SRC_URI="http://www.roland-riegel.de/nload/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc x86"

RDEPEND=">=sys-libs/ncurses-5.2:0="
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	eautoreconf
}

src_configure() {
	# --enable-debug means do not strip debugging symbols (default no)
	econf --enable-debug
}
