# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg flag-o-matic toolchain-funcs

DESCRIPTION="GAP package for computing with error-correcting codes"
HOMEPAGE="https://gap-packages.github.io/guava/"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"
LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="dev-gap/sonata"
DEPEND="sci-mathematics/gap"

GAP_PKG_EXTRA_INSTALL=( tbl )
gap-pkg_enable_tests

src_configure() {
	# "false" conflicts with c23 bool type
	append-cflags -std=c17
	gap-pkg_src_configure
}

src_compile() {
	# COMPILE, COMPOPT, LINKOPT are needed to compile the code in src/leon.
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		COMPILE="$(tc-getCC)" \
		COMPOPT="${CFLAGS} -c" \
		LINKOPT="${LDFLAGS}"
}

src_test() {
	gap-pkg_src_test
	emake check-programs
}
