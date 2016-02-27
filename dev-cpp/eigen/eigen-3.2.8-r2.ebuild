# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FORTRAN_NEEDED="test"

inherit cmake-utils fortran-2

DESCRIPTION="C++ template library for linear algebra"
HOMEPAGE="http://eigen.tuxfamily.org/"
SRC_URI="https://bitbucket.org/eigen/eigen/get/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="LGPL-2 GPL-3"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="altivec debug doc openmp test"
IUSE+=" cpu_flags_x86_sse2"
IUSE+=" cpu_flags_x86_sse3"
IUSE+=" cpu_flags_x86_sse4_1"
IUSE+=" cpu_flags_x86_sse4_2"
IUSE+=" cpu_flags_x86_ssse3"
#IUSE+=" cpu_flags_x86_x87"

RDEPEND="!dev-cpp/eigen:0"
DEPEND="
	doc? ( app-doc/doxygen[dot,latex] )
	test? (
		dev-libs/gmp:0
		dev-libs/mpfr:0
		media-libs/freeglut
		media-libs/glew
		sci-libs/adolc
		sci-libs/cholmod
		sci-libs/fftw:3.0
		sci-libs/pastix
		sci-libs/umfpack
		sci-libs/scotch
		sci-libs/spqr
		sci-libs/superlu
		dev-qt/qtcore:4
		virtual/opengl
		virtual/pkgconfig
	)
	"
# Missing:
# METIS-5
# GOOGLEHASH

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.7-pastix-5.2-backport.patch
	"${FILESDIR}"/${PN}-3.2.7-adaolc-backport.patch
)

src_unpack() {
	default
	mv ${PN}* ${P} || die
}

src_prepare() {
	sed \
		-e 's:-g2::g' \
		-i cmake/EigenConfigureTesting.cmake || die

	sed -i CMakeLists.txt \
		-e "/add_subdirectory(demos/d" \
		|| die "sed disable unused bundles failed"

	if ! use test; then
		sed -i CMakeLists.txt \
			-e "/add_subdirectory(blas/d" \
			-e "/add_subdirectory(lapack/d" \
			|| die "sed disable unused bundles failed"
	fi

	sed -i -e "/Unknown build type/d" CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile doc
}

src_test() {
	local mycmakeargs=(
		-DEIGEN_BUILD_TESTS=ON
		-DEIGEN_TEST_ALTIVEC="$(usex altivec)"
		-DEIGEN_TEST_OPENMP="$(usex openmp)"
		-DEIGEN_TEST_SSE2="$(usex cpu_flags_x86_sse2)"
		-DEIGEN_TEST_SSE3="$(usex cpu_flags_x86_sse3)"
		-DEIGEN_TEST_SSE4_1="$(usex cpu_flags_x86_sse4_1)"
		-DEIGEN_TEST_SSE4_2="$(usex cpu_flags_x86_sse4_2)"
		-DEIGEN_TEST_SSSE3="$(usex cpu_flags_x86_ssse3)"
#		-DEIGEN_TEST_X87="$(usex cpu_flags_x86_x87)"
	)
	cmake-utils_src_configure
	cmake-utils_src_compile blas
	cmake-utils_src_compile buildtests
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc -r "${BUILD_DIR}"/doc/html

	# Debian installs it and some projects started using it.
	insinto /usr/share/cmake/Modules/
	doins "${S}/cmake/FindEigen3.cmake"
}
