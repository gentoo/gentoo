# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Constrained Column approximate minimum degree ordering algorithm"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="http://202.36.178.9/sage//${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="virtual/pkgconfig"
DEPEND="sci-libs/suitesparseconfig"
RDEPEND="${DEPEND}"

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
