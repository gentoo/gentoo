# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="MASM-compatible TASM-similar assembler (fork of Wasm)"
HOMEPAGE="https://github.com/JWasm/JWasm"
SRC_URI="https://github.com/JWasm/JWasm/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Watcom-1.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND=""
BDEPEND=""

S="${WORKDIR}/JWasm-${PV}"

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
