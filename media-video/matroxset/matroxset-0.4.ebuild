# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

IUSE=""

DESCRIPTION="Matrox utility to switch output modes (activate tvout)"
HOMEPAGE="ftp://platan.vc.cvut.cz/pub/linux/matrox-latest/"
SRC_URI="ftp://platan.vc.cvut.cz/pub/linux/matrox-latest/${P}.tar.gz"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"

doecho() {
	echo "$@"
	"$@"
}

src_compile() {
	doecho $(tc-getCC) -o ${PN} \
		${CFLAGS} ${LDFLAGS} \
		${PN}.c -lncurses \
		|| die "build failed"

	#prepare small README
	cat >> "${S}"/README << _EOF_
This utility has been created by Petr Vandrovec

Not much info here, but here are some pointers
http://davedina.apestaart.org/download/doc/Matrox-TVOUT-HOWTO-0.1.txt
http://www.netnode.de/howto/matrox-fb.html
_EOF_
}

src_install() {
	dobin matroxset || die

	dodoc README || die
}
