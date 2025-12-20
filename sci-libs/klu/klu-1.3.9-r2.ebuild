# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Sparse LU factorization for circuit simulation"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="http://202.36.178.9/sage/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
IUSE="doc"

BDEPEND="
	virtual/pkgconfig
	doc? ( virtual/latex-base )"
DEPEND="
	>=sci-libs/amd-2.4
	>=sci-libs/btf-1.2
	>=sci-libs/colamd-2.9"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.3.9-dash_doc.patch )

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

	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
