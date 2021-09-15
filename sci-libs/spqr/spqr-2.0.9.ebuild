# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Multithreaded multifrontal sparse QR factorization library"
HOMEPAGE="http://faculty.cse.tamu.edu/davis/suitesparse.html"
SRC_URI="http://202.36.178.9/sage/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc partition tbb"

BDEPEND="virtual/pkgconfig
	doc? ( virtual/latex-base )"
# We require the cholmod supernodal module that is enabled with
# USE=lapack, and cholmod has to have partition support if spqr is going
# to have it (the ./configure script for spqr checks this). Note that
# spqr links to metis directly, too.
DEPEND="
	virtual/lapack
	>=sci-libs/cholmod-2[lapack,partition?]
	partition? ( >=sci-libs/metis-5.1.0 )
	tbb? ( dev-cpp/tbb )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--disable-static \
		$(use_with doc) \
		$(use_with partition) \
		$(use_with tbb)
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
