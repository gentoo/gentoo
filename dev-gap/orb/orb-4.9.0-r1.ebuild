# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg toolchain-funcs

DESCRIPTION="GAP methods to enumerate orbits"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64"
IUSE="examples test"
RESTRICT="!test? ( test )"

DEPEND="sci-mathematics/gap:="
RDEPEND="${DEPEND}"
BDEPEND="test? (
	dev-gap/atlasrep
	dev-gap/cvec
	dev-gap/io
)"

gap-pkg_enable_tests

pkg_setup() {
	tc-export CC
}

src_install() {
	gap-pkg_src_install
	use examples && dodoc -r examples
}
