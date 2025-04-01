# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Generate documentation from GAP source code"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"
S="${WORKDIR}/AutoDoc-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

# The test suite tries to LoadPackage this
BDEPEND="test? ( dev-gap/io )"
gap-pkg_enable_tests

src_prepare() {
	default
	rm -f makefile || die
}
