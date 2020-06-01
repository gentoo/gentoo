# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sparse LU factorization for circuit simulation"
HOMEPAGE="http://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="http://202.36.178.9/sage/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

BDEPEND="virtual/pkgconfig
	doc? ( virtual/latex-base )"
DEPEND="
	>=sci-libs/amd-2.4
	>=sci-libs/btf-1.2
	>=sci-libs/colamd-2.9"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with doc)
}
