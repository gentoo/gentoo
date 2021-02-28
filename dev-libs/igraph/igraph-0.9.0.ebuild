# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Creating and manipulating undirected and directed graphs"
HOMEPAGE="http://www.igraph.org/"
SRC_URI="https://github.com/igraph/igraph/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="~amd64 ~x86"
IUSE="debug test threads"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/libxml2
	sci-libs/arpack
	sci-libs/cxsparse
	sci-mathematics/glpk:=
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.9.0-cmakedirs.patch )

src_configure() {
	local mycmakeargs=(
		-DUSE_CCACHE=OFF
		-DIGRAPH_GLPK_SUPPORT=ON
		-DIGRAPH_GRAPHML_SUPPORT=ON
		-DIGRAPH_USE_INTERNAL_ARPACK=OFF
		-DIGRAPH_USE_INTERNAL_BLAS=OFF
		-DIGRAPH_USE_INTERNAL_CXSPARSE=OFF
		-DIGRAPH_USE_INTERNAL_GLPK=OFF
		-DIGRAPH_USE_INTERNAL_GMP=OFF
		-DIGRAPH_USE_INTERNAL_LAPACK=OFF
		-DIGRAPH_ENABLE_TLS=$(usex threads)
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	cmake_build check
}
