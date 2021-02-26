# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Creating and manipulating undirected and directed graphs"
HOMEPAGE="http://www.igraph.org/"
SRC_URI="https://github.com/igraph/igraph/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="~amd64 x86"
IUSE="debug"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/libxml2
	sci-libs/arpack
	sci-libs/cxsparse
	sci-mathematics/glpk:=
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-0.8.2-unbundle.patch )

src_prepare() {
	default
	rm -r src/lapack optional/glpk src/cs || die
	eautoreconf
}

src_configure() {
	# even with --with-external-f2c
	# we don't need f2c as none of
	#    arpack lapack blas
	# are internal
	tc-export PKG_CONFIG
	econf \
		$(use_enable debug) \
		--enable-gmp \
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
	find "${ED}" -name '*.la' -delete || die
}
