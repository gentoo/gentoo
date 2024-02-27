# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Nilpotent Quotients of finitely-presented groups"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="sci-mathematics/gap:=
	dev-libs/gmp:0="
RDEPEND="${DEPEND}
	dev-gap/polycyclic"

gap-pkg_enable_tests

src_install() {
	gap-pkg_src_install
	emake DESTDIR="${D}" install
	use examples && dodoc -r examples
}
