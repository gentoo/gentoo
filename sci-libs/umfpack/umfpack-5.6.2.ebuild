# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/umfpack/umfpack-5.6.2.ebuild,v 1.12 2015/05/13 07:01:52 jmorgan Exp $

EAPI=5

inherit autotools-utils toolchain-funcs

DESCRIPTION="Unsymmetric multifrontal sparse LU factorization library"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/umfpack"
SRC_URI="http://dev.gentoo.org/~bicatali/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~mips ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
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
