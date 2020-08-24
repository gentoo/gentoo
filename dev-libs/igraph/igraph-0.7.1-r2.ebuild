# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Creating and manipulating undirected and directed graphs"
HOMEPAGE="http://www.igraph.org/"
SRC_URI="http://www.igraph.org/nightly/get/c/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="~amd64 ~x86"
IUSE="debug gmp"

RDEPEND="
	dev-libs/libxml2
	>=sci-libs/arpack-3
	virtual/blas
	virtual/lapack
	>=sci-libs/cxsparse-3
	sci-mathematics/glpk
	gmp? ( dev-libs/gmp:0 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-unbundle.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export PKG_CONFIG
	econf \
		$(use_enable gmp) \
		$(use_enable debug) \
		--disable-static \
		--disable-tls \
		--with-external-arpack \
		--with-external-blas \
		--with-external-lapack \
		--with-external-f2c \
		--with-external-glpk
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
