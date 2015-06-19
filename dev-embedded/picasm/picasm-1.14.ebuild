# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/picasm/picasm-1.14.ebuild,v 1.5 2012/11/27 04:20:06 radhermit Exp $

EAPI=4

inherit toolchain-funcs flag-o-matic

MY_PV="${PV//.}"
MY_P="${PN}${MY_PV}"
DESCRIPTION="An assembler and disassembler for 12 and 14-bit PIC chips"
HOMEPAGE="http://www.iki.fi/trossi/pic/"
SRC_URI="http://www.iki.fi/trossi/pic/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e 's:$(CC):\0 $(LDFLAGS):' Makefile || die
}

src_compile() {
	append-cflags -DBUILTIN_INCLUDE1=\\\"/usr/share/picasm/include\\\"
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	dobin picasm
	dodoc picasm.txt HISTORY TODO

	insinto /usr/share/picasm/include
	doins device_definitions/*.i

	dohtml picasm.html
	docinto examples
	dodoc examples/*.*
	docompress -x /usr/share/doc/${PF}/examples
}
