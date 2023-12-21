# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools gap-pkg

DESCRIPTION="Bindings for low level C library I/O routines"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="sci-mathematics/gap:="
RDEPEND="${DEPEND}"

gap-pkg_enable_tests

src_prepare() {
	default

	# These tests require network access
	rm tst/http.g || die
	sed -e 's/"http.g", //' -i tst/testgap.tst || die

	# Support pathological CFLAGS
	eautoreconf
}

src_install() {
	# There's no install target for the autotools build system
	gap-pkg_src_install

	if use examples; then
		docinto examples
		dodoc example/*
	fi
}
