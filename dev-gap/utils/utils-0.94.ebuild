# Copyright 1999-2026 Gentoo Authors
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
	# Disable network tests, and sed out the line in testall.g that
	# tells AutoDoc to regenerate them.
	rm tst/{download,utils09}.tst || die
	sed -e '/makedoc\.g/d' -i tst/testall.g || die
	default
}
