# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Image viewer for w3m under frame buffer environment"
HOMEPAGE="http://homepage3.nifty.com/slokar/fb/w3mimg.html"
SRC_URI="http://homepage3.nifty.com/slokar/fb/${P}.tar.gz"

LICENSE="w3m BSD"
SLOT="0"
KEYWORDS="~amd64 x86 ppc"
IUSE=""

DEPEND="media-libs/stimg"
RDEPEND="${DEPEND}
	virtual/w3m"

src_prepare() {
	sed \
		-e '/^CC/d' \
		-e '/^CFLAGS/d' \
		-e '/^LDFLAGS/d' \
		-i Makefile || die
	tc-export CC
}

src_install() {
	exeinto /usr/libexec/w3m
	doexe w3mimgdisplayfb

	dodoc readme.txt
}
