# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="A java extension of BSD YACC-compatible parser generator"
HOMEPAGE="http://byaccj.sourceforge.net/"
MY_P="${PN}${PV}_src"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

S="${WORKDIR}/${PN}${PV}"

src_compile() {
	cp "${FILESDIR}/Makefile" src/Makefile || die
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" CFLAGS="${CFLAGS}" -C src linux
}

src_install() {
	newbin src/yacc.linux "${PN}"
	dodoc docs/ACKNOWLEDGEMEN
}
