# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake cuda toolchain-funcs

DESCRIPTION="Fast approximate nearest neighbor searches in high dimensional spaces"
HOMEPAGE="https://github.com/flann-lib/flann"
COMMIT="f9caaf609d8b8cb2b7104a85cf59eb92c275a25d"
SRC_URI="
	https://github.com/flann-lib/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz
	https://github.com/negril/gentoo-overlay-vendored/raw/refs/heads/blobs/${P}-patches-r1.tar.xz
"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~x86"
IUSE="cuda doc examples mpi octave openmp test"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		dev-tex/latex2html
	)
"
RDEPEND="
	app-arch/lz4:=
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	examples? (
		sci-libs/hdf5:=[mpi?]
	)
	mpi? (
		virtual/mpi
		dev-libs/boost:=[mpi]
		sci-libs/hdf5:=
	)
	octave? (
		>=sci-mathematics/octave-3.6.4-r1:=
	)
"
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest
		sci-libs/hdf5[mpi?]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.1-build-oct-rather-than-mex-files-for-octave.patch # bug 830424
	"${FILESDIR}"/${PN}-1.9.2-asio-boost187.patch
	"${FILESDIR}"/${PN}-1.9.2-boost-config-1.89.patch
	"${FILESDIR}"/${PN}-1.9.2-system-gtest.patch
	"${FILESDIR}"/${PN}-1.9.2-gettimeofday.patch

	# "${FILESDIR}/${PN}-1.9.2-lz4-dependency-fix.patch" # https://github.com/flann-lib/flann/pull/523
	# "${FILESDIR}/${PN}-1.9.2-fix-build.patch"
	# "${FILESDIR}/${PN}-1.9.2-allow-user-CUDAARCHS.patch"
	# "${FILESDIR}/${PN}-1.9.2-use-gtest_discover_tests.patch"
	# "${FILESDIR}/${PN}-1.9.2-loosen-test-precision.patch"
	# "${FILESDIR}/${PN}-1.9.2-cleanup-find_HDF5.patch"
	# "${FILESDIR}/${PN}-1.9.2-add-USE_CPACK.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake_src_prepare

	for patch in "${WORKDIR}/${P}-patches-r1"/*; do
		eapply "${patch}"
	done
}

src_configure() {
	# python bindings were split off into dev-python/pyflann
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=17
		-DBUILD_C_BINDINGS="yes"
		-DBUILD_PYTHON_BINDINGS="no"
		-DBUILD_CUDA_LIB="$(usex cuda)"
		-DBUILD_EXAMPLES="$(usex examples)"
		-DBUILD_DOC="$(usex doc)"
		-DBUILD_TESTS="$(usex test)"
		-DBUILD_MATLAB_BINDINGS="$(usex octave)"
		-DUSE_MPI="$(usex mpi)"
		-DUSE_OPENMP="$(usex openmp)"
		-DCMAKE_BUILD_STATIC_LIBS="no"
	)

	if use cuda; then
		cuda_add_sandbox -w

		export CUDAHOSTCXX="$(cuda_gccdir)"
		export CUDAHOSTLD="$(tc-getCXX)"
	fi

	use doc && mycmakeargs+=( -DDOCDIR="share/doc/${PF}" )

	cmake_src_configure
}

src_compile() {
	local targets=( "all" )

	use doc && targets+=( "doc" )

	if use test; then
		targets+=( "flann_gtests" )
		if use cuda; then
			targets+=( "flann_cuda_test" )
		fi
	fi

	cmake_src_compile "${targets[@]}"
}

src_test() {
	if use cuda; then
		addpredict "/dev/char/"
		cuda_add_sandbox -w
	fi

	# some fail when run in parallel
	cmake_src_test -j1
}
