# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DOCS_BUILDER="sphinx"
DOCS_DEPEND="dev-python/sphinx-rtd-theme"
DOCS_DIR="docs/source"
inherit cmake-multilib cuda flag-o-matic python-any-r1 docs

DESCRIPTION="Nonlinear least-squares minimizer"
HOMEPAGE="http://ceres-solver.org/"
SRC_URI="http://ceres-solver.org/${P}.tar.gz"

LICENSE="sparse? ( BSD ) !sparse? ( LGPL-2.1 )"
SLOT="0/1"
KEYWORDS="amd64 ~x86"
IUSE="examples cuda gflags lapack +schur sparse test"

REQUIRED_USE="test? ( gflags ) sparse? ( lapack ) abi_x86_32? ( !sparse !lapack )"
RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	>=dev-cpp/eigen-3.3.4:3
	lapack? ( virtual/pkgconfig )
	doc? ( <dev-libs/mathjax-3 )
"
RDEPEND="
	dev-cpp/glog[gflags?,${MULTILIB_USEDEP}]
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
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

PATCHES=(
	"${FILESDIR}/${PN}-2.0.0-system-mathjax.patch"
	"${FILESDIR}/${PN}-2.2.0-include-algorithm.patch"
)

src_prepare() {
	cmake_src_prepare

	filter-lto

	# search paths work for prefix
	sed -e "s:/usr:${EPREFIX}/usr:g" \
		-i cmake/*.cmake || die

	# remove Werror
	sed -e 's/-Werror=(all|extra)//g' \
		-i CMakeLists.txt || die
}

src_configure() {
	# CUSTOM_BLAS=OFF EIGENSPARSE=OFF MINIGLOG=OFF
	local mycmakeargs=(
		-DBUILD_BENCHMARKS=OFF
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_TESTING=$(usex test)
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DGFLAGS=$(usex gflags)
		-DLAPACK=$(usex lapack)
		-DSCHUR_SPECIALIZATIONS=$(usex schur)
		-DSUITESPARSE=$(usex sparse)
		-DEigen3_DIR=/usr/$(get_libdir)/cmake/eigen3

		-DBUILD_SHARED_LIBS="yes"
		-DEIGENMETIS="yes"
		-DEIGENSPARSE="yes"
		-DMINIGLOG="no"
		-DCUSTOM_BLAS="yes"
		-DUSE_CUDA="$(usex cuda)"
	)

	if use cuda; then
		: "${CUDAHOSTCXX:=$(cuda_gccdir)}"
		: "${CUDAARCHS:=all}"
		export CUDAHOSTCXX
		export CUDAARCHS
	fi

	use sparse || mycmakeargs+=( -DEIGENSPARSE=ON )

	cmake-multilib_src_configure
}

src_test() {
	use cuda && cuda_add_sandbox -w
	cmake-multilib_src_test
}

src_install() {
	cmake-multilib_src_install

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples data
	fi
}
