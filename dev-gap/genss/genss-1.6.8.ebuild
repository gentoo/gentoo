# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="GAP implementation of the randomized Schreier-Sims algorithm"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND="dev-gap/io
	dev-gap/orb"

gap-pkg_enable_tests

src_install() {
	gap-pkg_src_install
	use examples && dodoc -r examples
}
