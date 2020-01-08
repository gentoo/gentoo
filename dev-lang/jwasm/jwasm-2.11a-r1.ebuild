# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

# 2.10 -> 210s
MY_PN=JWasm
MY_PV="$(ver_rs 1 '')s"
MY_P="${MY_PN}${MY_PV}"

DESCRIPTION="MASM-compatible TASM-similar assembler (fork of Wasm)"
HOMEPAGE="https://sourceforge.net/projects/jwasm/"
SRC_URI="mirror://sourceforge/${PN}/JWasm%20Source%20Code/${MY_P}.zip"
LICENSE="Watcom-1.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND=""
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

PATCHES=("${FILESDIR}"/${PN}-2.11-types-test.patch)

src_prepare() {
	default

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
