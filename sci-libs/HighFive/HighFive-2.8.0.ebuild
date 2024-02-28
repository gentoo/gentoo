# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="app-text/doxygen[dot]"
DOCS_DIR="doc"

inherit cmake docs

DESCRIPTION="Header-only C++ interface for libhdf5"
HOMEPAGE="https://github.com/BlueBrain/HighFive"
SRC_URI="https://github.com/BlueBrain/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 ~x86"
LICENSE="Boost-1.0"
SLOT="0"
IUSE="mpi test"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-libs/hdf5[mpi?]
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-cpp/catch-3.4.0:0
		dev-libs/boost
		dev-cpp/eigen
		media-libs/opencv
	)
"

DOCS=( {README,CHANGELOG}.md )

src_configure() {
	default
	local mycmakeargs=(
		-DHIGHFIVE_PARALLEL_HDF5=$(usex mpi)

		-DHIGHFIVE_USE_BOOST=$(usex test)
		-DHIGHFIVE_USE_EIGEN=$(usex test)
		-DHIGHFIVE_USE_OPENCV=$(usex test)
		-DHIGHFIVE_USE_XTENSOR=OFF

		-DHIGHFIVE_EXAMPLES=$(usex test)
		-DHIGHFIVE_UNIT_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	default
	use test && cmake_src_compile
	use doc && doxygen_compile
}

src_test() {
	# Set -j1 to prevent race
	cmake_src_test -j1
}
