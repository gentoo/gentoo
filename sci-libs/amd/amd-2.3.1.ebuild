# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/amd/amd-2.3.1.ebuild,v 1.10 2015/05/13 05:58:22 jmorgan Exp $

EAPI=5

inherit autotools-utils fortran-2

DESCRIPTION="Library to order a sparse matrix prior to Cholesky factorization"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/amd"
SRC_URI="http://dev.gentoo.org/~bicatali/distfiles/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc fortran static-libs"

RDEPEND="sci-libs/suitesparseconfig"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

src_configure() {
	local myeconfargs=(
		$(use_enable fortran)
		$(use_with doc)
	)
	autotools-utils_src_configure
}
