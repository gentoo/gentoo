# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{7,8,9} )
inherit cmake-multilib python-any-r1 toolchain-funcs

DESCRIPTION="Nonlinear least-squares minimizer"
HOMEPAGE="http://ceres-solver.org/"
SRC_URI="http://ceres-solver.org/${P}.tar.gz"

LICENSE="sparse? ( BSD ) !sparse? ( LGPL-2.1 ) cxsparse? ( BSD )"
SLOT="0/1"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cxsparse doc examples gflags lapack openmp +schur sparse test"

REQUIRED_USE="test? ( gflags ) sparse? ( lapack ) abi_x86_32? ( !sparse !lapack )"

RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	>=dev-cpp/eigen-3.3.4:3
	doc? (
		dev-python/sphinx
		dev-python/sphinx_rtd_theme
	)
	lapack? ( virtual/pkgconfig )
"
RDEPEND="
	dev-cpp/glog[gflags?,${MULTILIB_USEDEP}]
	cxsparse? ( sci-libs/cxsparse )
	lapack? ( virtual/lapack )
	sparse? (
		sci-libs/amd
		sci-libs/camd
		sci-libs/ccolamd
		sci-libs/cholmod[metis(+)]
		sci-libs/colamd
		sci-libs/spqr
	)
"
DEPEND="${RDEPEND}"

DOCS=( README.md VERSION )

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		if [[ $(tc-getCXX) == *g++* ]] && ! tc-has-openmp; then
			ewarn "OpenMP is not available in your current selected gcc"
			die "need openmp capable gcc"
		fi
	fi
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	# search paths work for prefix
	sed -e "s:/usr:${EPREFIX}/usr:g" \
		-i cmake/*.cmake || die

	# remove Werror
	sed -e 's/-Werror=(all|extra)//g' \
		-i CMakeLists.txt || die
}

src_configure() {
	# CUSTOM_BLAS=OFF EIGENSPARSE=OFF MINIGLOG=OFF CXX11=OFF
	local mycmakeargs=(
		-DBUILD_BENCHMARKS=OFF
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTING=$(usex test)
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DGFLAGS=$(usex gflags)
		-DLAPACK=$(usex lapack)
		-DOPENMP=$(usex openmp)
		-DSCHUR_SPECIALIZATIONS=$(usex schur)
		-DCXSPARSE=$(usex cxsparse)
		-DSUITESPARSE=$(usex sparse)
	)
	use doc && mycmakeargs+=(
		-DCERES_DOCS_INSTALL_DIR="${EPREFIX}"/usr/share/doc/${PF}
	)
	use sparse || use cxsparse || mycmakeargs+=( -DEIGENSPARSE=ON )
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples data
	fi
}
