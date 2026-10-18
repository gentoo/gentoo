# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="Software package for algebraic, geometric and combinatorial problems"
HOMEPAGE="https://4ti2.github.io"
SRC_URI="https://github.com/4ti2/4ti2/releases/download/Release_${PV//./_}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~riscv ~x86"

RDEPEND="
	sci-mathematics/glpk:=[gmp(+)]
	dev-libs/gmp:0=[cxx(+)]"
DEPEND="${RDEPEND}"

src_configure() {
	# This is not pointless: configure.ac disables shared libraries and
	# enables static libraries by default.
	econf --enable-shared --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
