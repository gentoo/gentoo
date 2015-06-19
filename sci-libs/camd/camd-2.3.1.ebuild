# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/camd/camd-2.3.1.ebuild,v 1.11 2015/05/13 06:58:37 jmorgan Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Library to order a sparse matrix prior to Cholesky factorization"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/camd/"
SRC_URI="http://dev.gentoo.org/~bicatali/distfiles/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="amd64 ~arm hppa ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc static-libs"

RDEPEND="sci-libs/suitesparseconfig"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

src_configure() {
	local myeconfargs=(
		$(use_with doc)
	)
	autotools-utils_src_configure
}
