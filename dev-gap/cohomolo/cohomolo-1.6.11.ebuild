# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Cohomology groups of finite groups on finite modules"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"

DEPEND="sci-mathematics/gap"

GAP_PKG_HTML_DOCDIR="htm"
GAP_PKG_EXTRA_INSTALL=( testdata standalone )

gap-pkg_enable_tests

src_install() {
	# Remove standalone/progs.d so that it is not installed below. It
	# contains the source code for the executable that we built.
	rm -r standalone/progs.d || die
	gap-pkg_src_install
}
