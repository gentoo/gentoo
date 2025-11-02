# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Quivers and Path Algebras in GAP"
SRC_URI="https://github.com/gap-packages/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="examples"

RDEPEND="dev-gap/gbnp"

gap-pkg_enable_tests

src_install() {
	gap-pkg_src_install
	use examples && dodoc -r examples
}
