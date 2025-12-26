# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="app-text/doxygen[dot]"
DOCS_DIR="doc"

inherit cmake docs

## The development of HighFive will continue at https://github.com/highfive-devs/highfive
## instead of https://github.com/BlueBrain/HighFive
DESCRIPTION="Header-only C++ interface for libhdf5"
HOMEPAGE="https://highfive-devs.github.io/highfive/"
SRC_URI="https://github.com/${PN}-devs/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
		dev-cpp/eigen:=
		media-libs/opencv
	)
"

DOCS=( {README,CHANGELOG}.md )

PATCHES="${FILESDIR}/${P}_use_system_catch2_fix_QA_cmake4_warning.patch"

src_configure() {
	default
	local mycmakeargs=(
		-DHDF5_IS_PARALLEL=$(usex mpi)

		-DHIGHFIVE_TEST_BOOST=$(usex test)
		-DHIGHFIVE_TEST_EIGEN=$(usex test)
		-DHIGHFIVE_TEST_OPENCV=$(usex test)
		-DHIGHFIVE_TEST_XTENSOR=OFF

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
