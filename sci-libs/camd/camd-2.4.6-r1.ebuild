# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library to order a sparse matrix prior to Cholesky factorization"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="http://202.36.178.9/sage/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

BDEPEND="virtual/pkgconfig
	doc? ( virtual/latex-base )"
DEPEND=">=sci-libs/suitesparseconfig-5.4.0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-2.4.6-dash_doc.patch )

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_with doc)
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
