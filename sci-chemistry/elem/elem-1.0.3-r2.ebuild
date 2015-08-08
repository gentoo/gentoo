# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="periodic table of the elements"
HOMEPAGE="http://elem.sourceforge.net/"
SRC_URI="mirror://sourceforge/elem/${PN}-src-${PV}-Linux.tgz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~sparc ~x86"
SLOT="0"
IUSE=""

DEPEND="x11-libs/xforms"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e 's:\(^LIBS = .*\):\1 -lXpm:' \
		-e "s:\${FLAGS} -o elem:\$(LDFLAGS) &:" \
		-i Makefile || die #336190
	sed -e "/string.h/ i #include <stdlib.h>" \
		-i elem_cb.c || die #implicit exit()
}

src_compile () {
	emake COMPILER="$(tc-getCC)" FLAGS="${CFLAGS}" all || die "Build failed."
}

src_install () {
	dobin elem elem-de elem-en || die
	dohtml -r doc/* || die
}
