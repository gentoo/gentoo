# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="MASM-compatible TASM-similar assembler (fork of Wasm)"
HOMEPAGE="https://github.com/Baron-von-Riedesel/JWasm"
SRC_URI="https://github.com/Baron-von-Riedesel/JWasm/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/JWasm-${PV}"

LICENSE="Watcom-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-2.18-types-test.patch
	"${FILESDIR}"/${PN}-2.18-makefile-dep-fix.patch
)

src_prepare() {
	default

	# don't strip binary
	sed -i GccUnix.mak -e 's/ -s / /g' || die
}

src_compile() {
	emake -f GccUnix.mak CC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin build/GccUnixR/jwasm
	dodoc -r README.md History.txt Html/
}
