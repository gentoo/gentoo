# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit toolchain-funcs

DESCRIPTION="A program to give information about RCS files"
HOMEPAGE="http://www.colinbrough.pwp.blueyonder.co.uk/rcsi.README.html"
SRC_URI="http://www.colinbrough.pwp.blueyonder.co.uk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="sys-apps/sed"
RDEPEND=">=dev-vcs/rcs-5.7-r2"

S=${WORKDIR}/${PN}

src_compile() {
	$(tc-getCC) $CFLAGS $LDFLAGS rcsi.c -o rcsi || die "Compile failed"
}

src_install() {
	dobin rcsi
	doman rcsi.1
	dodoc README
	dohtml README.html example{1,2}.png
}
