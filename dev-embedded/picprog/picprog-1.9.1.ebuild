# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A PIC16, PIC18 and dsPIC microcontroller programmer software for the serial port"
HOMEPAGE="http://hyvatti.fi/~jaakko/pic/picprog.html"
SRC_URI="http://hyvatti.fi/~jaakko/pic/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

src_compile() {
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin picprog
	dodoc README
	docinto html
	dodoc picprog.html *.png
	doman picprog.1
}
