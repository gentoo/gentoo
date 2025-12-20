# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A Java extension of BSD YACC-compatible parser generator"
HOMEPAGE="https://byaccj.sourceforge.net/"
MY_P="${PN}${PV}_src"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos"

S="${WORKDIR}/${PN}${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.15-implicit-function-declaration.patch
)

src_compile() {
	cp "${FILESDIR}/Makefile" src/Makefile || die

	# bug #880329, bug #944104
	append-cflags -std=gnu17
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" CFLAGS="${CFLAGS}" -C src linux
}

src_install() {
	newbin src/yacc.linux "${PN}"
	dodoc docs/ACKNOWLEDGEMEN
}
