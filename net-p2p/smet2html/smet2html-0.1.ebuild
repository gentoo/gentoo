# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="Convert eDonkey2000 server.met to html"
HOMEPAGE="http://ed2k-tools.sourceforge.net/${PN}.shtml"
SRC_URI="mirror://sourceforge/ed2k-tools/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i -e "s:gcc -Wall:gcc ${CFLAGS} -Wall:g" ${S}/Makefile
}

src_compile() {
	make || die "make failed"
}

src_install() {
	dobin smet2html
}
