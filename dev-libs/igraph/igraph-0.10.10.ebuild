# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Creating and manipulating undirected and directed graphs"
HOMEPAGE="https://igraph.org/"
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
	sci-mathematics/glpk:=
	sci-mathematics/plfit
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}"

PATCHES=(
	# backport fix for strict-aliasing
	"${FILESDIR}"/808c083fbe661207ee8f0fcd3be5096b5dc17d0d.patch
)

src_configure() {
	local mycmakeargs=(
		-DUSE_CCACHE=OFF
		-DIGRAPH_GLPK_SUPPORT=ON
		-DIGRAPH_GRAPHML_SUPPORT=ON
		-DIGRAPH_USE_INTERNAL_ARPACK=OFF
		-DIGRAPH_USE_INTERNAL_BLAS=OFF
		-DIGRAPH_USE_INTERNAL_GLPK=OFF
		-DIGRAPH_USE_INTERNAL_GMP=OFF
		-DIGRAPH_USE_INTERNAL_LAPACK=OFF
		-DIGRAPH_USE_INTERNAL_PLFIT=OFF
		-DIGRAPH_ENABLE_TLS=$(usex threads)
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	cmake_build check
}
