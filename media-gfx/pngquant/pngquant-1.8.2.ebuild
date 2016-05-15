# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="command-line utility and library for lossy compression of PNG images"
HOMEPAGE="http://pngquant.org/"
SRC_URI="http://pngquant.org/${P}-src.tar.bz2"

LICENSE="HPND rwpng"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libpng:0=
	sys-libs/zlib:="
DEPEND=${RDEPEND}

src_prepare() {
	# Failure in upstream logic. Otherwise we lose the -I and -L flags
	# from Makefile.
	sed -i \
		-e 's:CFLAGS ?=:CFLAGS +=:' \
		-e 's:LDFLAGS ?=:LDFLAGS +=:' \
		Makefile || die
}

src_compile() {
	tc-export CC
	emake CFLAGSOPT=''
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc CHANGELOG README.md
}
