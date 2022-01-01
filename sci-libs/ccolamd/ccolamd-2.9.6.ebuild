# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Constrained Column approximate minimum degree ordering algorithm"
HOMEPAGE="http://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="http://202.36.178.9/sage//${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="static-libs"

BDEPEND="virtual/pkgconfig"
DEPEND="sci-libs/suitesparseconfig"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable static-libs static)
}
