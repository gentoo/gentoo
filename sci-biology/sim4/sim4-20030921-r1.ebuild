# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/sim4/sim4-20030921-r1.ebuild,v 1.1 2010/09/01 15:16:59 xarthisius Exp $

inherit toolchain-funcs

DESCRIPTION="A program to align cDNA and genomic DNA"
HOMEPAGE="http://globin.cse.psu.edu/html/docs/sim4.html"
SRC_URI="http://globin.cse.psu.edu/ftp/dist/sim4/sim4.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${PN}.2003-09-21

src_compile() {
	echo "$(tc-getCC) -o ${PN} ${LDFLAGS} -I. ${CFLAGS} *.c -lm"
	$(tc-getCC) -o ${PN} ${LDFLAGS} -I. ${CFLAGS} *.c -lm || die
}

src_install() {
	dobin ${PN} || die
	dodoc README.* VERSION || die
}
