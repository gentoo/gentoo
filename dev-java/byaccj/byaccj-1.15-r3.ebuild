# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A Java extension of BSD YACC-compatible parser generator"
HOMEPAGE="https://byaccj.sourceforge.net/"
MY_P="${PN}${PV}_src"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~ppc-macos ~x64-macos"

S="${WORKDIR}/${PN}${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.15-implicit-function-declaration.patch
)

src_compile() {
	cp "${FILESDIR}/Makefile" src/Makefile || die
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" CFLAGS="${CFLAGS}" -C src linux
}

src_install() {
	newbin src/yacc.linux "${PN}"
	dodoc docs/ACKNOWLEDGEMEN
}
