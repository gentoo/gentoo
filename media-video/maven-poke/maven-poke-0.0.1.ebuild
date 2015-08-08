# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Matrox utility to read and set maven registers (tune tvout)"
HOMEPAGE="ftp://platan.vc.cvut.cz/pub/linux/matrox-latest/"
SRC_URI="ftp://platan.vc.cvut.cz/pub/linux/matrox-latest/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

src_compile() {
	emake all || die

	#prepare small README
	cat >> "${S}"/README << _EOF_
This utility has been created by Petr Vandrovec.
It was formerly called maven-prog (and the executable was matrox).

A listing of maven registers
http://platan.vc.cvut.cz/~vana/maven/mavenreg.html

Not much info here, but here are some pointers
http://davedina.apestaart.org/download/doc/Matrox-TVOUT-HOWTO-0.1.txt
http://www.netnode.de/howto/matrox-fb.html
_EOF_
}

src_install() {
	newbin matrox maven-poke || die
	dodoc README
}
