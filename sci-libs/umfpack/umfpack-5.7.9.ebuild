# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Unsymmetric multifrontal sparse LU factorization library"
HOMEPAGE="http://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="http://202.36.178.9/sage/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc +cholmod static-libs"

BDEPEND="virtual/pkgconfig
	doc? ( virtual/latex-base )"
DEPEND="sci-libs/amd
	>=sci-libs/suitesparseconfig-5.4.0
	virtual/blas
	cholmod? ( sci-libs/cholmod )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		$(use_with doc) \
		$(use_enable static-libs static) \
		$(use_with cholmod)
}

src_compile() {
	use doc && export VARTEXFONTS="${T}/fonts"
	default
}
