# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

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
	"${FILESDIR}"/${PN}-2.18-missing-includes.patch #944893
	"${FILESDIR}"/${PN}-2.19-respect-ldflags.patch
)

src_compile() {
	# -std=c17 and -D_POSIX_C_SOURCE=200809L are both related to bug #944893
	append-cflags -std=c17
	emake -f GccUnix.mak CC="$(tc-getCC)" extra_c_flags="-D_POSIX_C_SOURCE=200809L ${CFLAGS}"
}

src_install() {
	dobin build/GccUnixR/jwasm
	dodoc -r README.md History.txt Html/
}
