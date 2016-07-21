# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="Multithreaded multifrontal sparse QR factorization library"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/SPQR"
SRC_URI="https://dev.gentoo.org/~bicatali/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc metis static-libs tbb"
RDEPEND="
	virtual/lapack
	>=sci-libs/cholmod-2[metis?]
	tbb? ( dev-cpp/tbb )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

src_configure() {
	local myeconfargs+=(
		$(use_with doc)
		$(use_with metis partition)
		$(use_with tbb)
	)
	autotools-utils_src_configure
}
