# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils toolchain-funcs

DESCRIPTION="Unsymmetric multifrontal sparse LU factorization library"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/umfpack"
SRC_URI="https://dev.gentoo.org/~bicatali/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc +cholmod static-libs"

RDEPEND="
	>=sci-libs/amd-1.3
	sci-libs/suitesparseconfig
	virtual/blas
	cholmod? ( >=sci-libs/cholmod-2[-minimal] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

src_configure() {
	local myeconfargs=(
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		$(use_with doc)
		$(use_with cholmod)
	)
	autotools-utils_src_configure
}
