# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs versionator

# 2.10 -> 210s
MY_PN=JWasm
MY_PV="$(delete_version_separator 1)s"
MY_P="${MY_PN}${MY_PV}"

DESCRIPTION="MASM-compatible TASM-similar assembler (fork of Wasm)"
HOMEPAGE="https://sourceforge.net/projects/jwasm/"
SRC_URI="mirror://sourceforge/${PN}/JWasm%20Source%20Code/${MY_P}.zip"
LICENSE="Watcom-1.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND=""

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.11-types-test.patch
	# don't strip binary
	sed -i GccUnix.mak -e 's/ -s / /g' || die
}

src_compile() {
	emake -f GccUnix.mak CC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin GccUnixR/jwasm
	dodoc *.txt Doc/*.txt
}
