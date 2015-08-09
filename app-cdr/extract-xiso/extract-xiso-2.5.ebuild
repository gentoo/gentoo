# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

MY_PV=${PV/_beta/b}

DESCRIPTION="Tool for extracting and creating optimised Xbox ISO images"
HOMEPAGE="http://sourceforge.net/projects/extract-xiso"
SRC_URI="mirror://sourceforge/extract-xiso/${PN}_v${MY_PV}_src.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e 's:__LINUX__:__linux__:' \
		*.[ch] */*.[ch] || die
}

doit() { echo "$@"; "$@"; }

src_compile() {
	doit $(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} \
		extract-xiso.c libftp-*/*.c -o extract-xiso || die
}

src_install() {
	dobin extract-xiso || die
	dodoc README.TXT
}
