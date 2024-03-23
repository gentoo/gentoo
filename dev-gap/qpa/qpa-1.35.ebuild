# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Quivers and Path Algebras in GAP"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND="dev-gap/gbnp"

gap-pkg_enable_tests

src_install() {
	gap-pkg_src_install
	use examples && dodoc -r examples
}
