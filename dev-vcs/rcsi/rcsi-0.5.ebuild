# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A program to give information about RCS files"
HOMEPAGE="http://www.colinbrough.pwp.blueyonder.co.uk/rcsi.README.html"
SRC_URI="http://www.colinbrough.pwp.blueyonder.co.uk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-vcs/rcs-5.7-r2"

S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin rcsi

	dodoc README
	docinto html
	dodoc README.html example{1,2}.png
	doman rcsi.1
}
