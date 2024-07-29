# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Compact vectors over finite fields in GAP"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="sci-mathematics/gap:="
RDEPEND="${DEPEND}
	dev-gap/io
	dev-gap/orb"

gap-pkg_enable_tests

src_install() {
	gap-pkg_src_install

	if use examples; then
		docinto examples
		dodoc example/*
	fi
}
