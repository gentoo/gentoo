# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic gap-pkg toolchain-funcs

DESCRIPTION="GAP package for computing with error-correcting codes"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="~amd64"

DEPEND="sci-mathematics/gap"

PATCHES=( "${FILESDIR}/${PN}-3.15-makefile.patch" )

GAP_PKG_EXTRA_INSTALL=( tbl )
gap-pkg_enable_tests

src_prepare() {
	# remove temporary files in src/leon
	rm src/leon/src/stamp-h1 || die
	default
}

src_configure() {
	# https://github.com/gap-packages/guava/issues/90
	append-cflags -Wno-error=strict-prototypes

	# This will run the top-level fake ./configure...
	gap-pkg_src_configure

	# Now run the real one in src/leon
	cd src/leon || die
	econf
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
