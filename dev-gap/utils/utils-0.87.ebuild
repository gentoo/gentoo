# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Utility functions in GAP"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="dev-gap/autodoc
	dev-gap/polycyclic"

DOCS=( CHANGES.md README.md )

gap-pkg_enable_tests

src_prepare() {
	# disable network tests
	rm tst/download.tst || die
	default
}
