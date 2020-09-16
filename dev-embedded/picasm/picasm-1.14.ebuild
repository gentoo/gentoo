# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV="${PV//.}"
MY_P="${PN}${MY_PV}"

DESCRIPTION="An assembler and disassembler for 12 and 14-bit PIC chips"
HOMEPAGE="http://www.iki.fi/trossi/pic/"
SRC_URI="http://www.iki.fi/trossi/pic/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 x86"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin picasm
	dodoc picasm.txt HISTORY TODO

	insinto /usr/share/picasm/include
	doins device_definitions/*.i

	docinto examples
	dodoc examples/*.*
	docompress -x /usr/share/doc/${PF}/examples

	docinto html
	dodoc picasm.html
}
