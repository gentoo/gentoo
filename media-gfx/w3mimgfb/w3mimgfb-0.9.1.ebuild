# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Image viewer for w3m under frame buffer environment"
HOMEPAGE="http://homepage3.nifty.com/slokar/fb/w3mimg.html"
SRC_URI="http://homepage3.nifty.com/slokar/fb/${P}.tar.gz"

LICENSE="w3m BSD"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="media-libs/stimg"
RDEPEND="${DEPEND}
	virtual/w3m
"

src_prepare() {
	default
	sed \
		-e '/^CC/d' \
		-e '/^CFLAGS/d' \
		-e '/^LDFLAGS/d' \
		-e 's/LIBS= -lstimg/LIBS= -lstimg -lpng -ljpeg -ltiff/g' \
		-i Makefile || die
	tc-export CC
}

src_install() {
	exeinto /usr/libexec/w3m
	doexe w3mimgdisplayfb

	dodoc readme.txt
}
