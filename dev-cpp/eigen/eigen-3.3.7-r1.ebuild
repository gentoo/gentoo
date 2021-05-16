# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEEDED="test"
inherit cmake cuda fortran-2

DESCRIPTION="C++ template library for linear algebra"
HOMEPAGE="http://eigen.tuxfamily.org/index.php?title=Main_Page"
SRC_URI="https://gitlab.com/libeigen/eigen/-/archive/${PV}/${P}.tar.bz2 -> ${P}-gitlab.tar.bz2"

LICENSE="MPL-2.0"
SLOT="3"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_arm_neon cpu_flags_ppc_altivec cpu_flags_ppc_vsx cuda debug doc openmp test" #zvector

RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		app-doc/doxygen[dot]
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	test? ( virtual/pkgconfig )
"
DEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit )
	test? (
		dev-libs/gmp:0
		dev-libs/mpfr:0
		media-libs/freeglut
		media-libs/glew
		sci-libs/adolc[sparse]
		sci-libs/cholmod
		sci-libs/fftw:3.0
		sci-libs/pastix
		sci-libs/scotch
		sci-libs/spqr
		sci-libs/superlu
		sci-libs/umfpack
		virtual/opengl
	)
"
# Missing:
# METIS-5
# GOOGLEHASH

PATCHES=( "${FILESDIR}"/${P}-gentoo-cmake.patch )

src_prepare() {
	cmake_src_prepare

	cmake_comment_add_subdirectory demos

	if ! use test; then
		sed -e "/add_subdirectory(test/s/^/#DONOTCOMPILE /g" \
			-e "/add_subdirectory(blas/s/^/#DONOTCOMPILE /g" \
			-e "/add_subdirectory(lapack/s/^/#DONOTCOMPILE /g" \
			-i CMakeLists.txt || die
	fi

	use cuda && cuda_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKEPACKAGE_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)/cmake/${PN}${SLOT}
	)
	use test && mycmakeargs+=(
		-DEIGEN_TEST_CXX11=ON
		-DEIGEN_TEST_NOQT=ON
		-DEIGEN_TEST_ALTIVEC=$(usex cpu_flags_ppc_altivec)
		-DEIGEN_TEST_CUDA=$(usex cuda)
		-DEIGEN_TEST_OPENMP=$(usex openmp)
		-DEIGEN_TEST_NEON64=$(usex cpu_flags_arm_neon)
		-DEIGEN_TEST_VSX=$(usex cpu_flags_ppc_vsx)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
	if use test; then
		cmake_src_compile blas
		cmake_src_compile buildtests
	fi
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	cmake_src_install
}
