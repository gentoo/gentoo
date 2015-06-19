# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/picprog/picprog-1.9.1.ebuild,v 1.5 2014/08/10 20:04:03 slyfox Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="A PIC16, PIC18 and dsPIC microcontroller programmer software for the serial port"
HOMEPAGE="http://www.iki.fi/hyvatti/pic/picprog.html"
SRC_URI="http://www.iki.fi/hyvatti/pic/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

src_compile() {
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin picprog
	dodoc README
	dohtml picprog.html *.png
	doman picprog.1
}
