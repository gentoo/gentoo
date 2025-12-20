# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake cuda toolchain-funcs

DESCRIPTION="Fast approximate nearest neighbor searches in high dimensional spaces"
HOMEPAGE="https://github.com/flann-lib/flann"
COMMIT="f9caaf609d8b8cb2b7104a85cf59eb92c275a25d"
SRC_URI="
	https://github.com/flann-lib/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-patches.tar.xz
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
	mpi? (
		app-admin/chrpath
	)
"
DEPEND="
	app-arch/lz4:=
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	examples? (
		sci-libs/hdf5:=[mpi?]
	)
	mpi? (
		dev-libs/boost:=[mpi]
		sci-libs/hdf5[mpi]
	)
	octave? (
		>=sci-mathematics/octave-3.6.4-r1:=
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.1-build-oct-rather-than-mex-files-for-octave.patch # bug 830424
	"${FILESDIR}"/${PN}-1.9.2-asio-boost187.patch
	"${FILESDIR}"/${PN}-1.9.2-boost-config.patch
	"${FILESDIR}"/${PN}-1.9.2-system-gtest.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	# bug #302621
	use mpi && export CXX=mpicxx

	cmake_src_prepare
	for patch in "${WORKDIR}/${P}-patches"/*; do
		eapply "${patch}"
	done
}

src_configure() {

	# python bindings are split off into dev-python/pyflann
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=17
		-DBUILD_C_BINDINGS="yes"
		-DBUILD_PYTHON_BINDINGS="no"
		-DBUILD_CUDA_LIB="$(usex cuda)"
		-DBUILD_EXAMPLES="$(usex examples)"
		-DBUILD_DOC="$(usex doc)"
		-DBUILD_TESTS="$(usex test)"
		-DBUILD_MATLAB_BINDINGS="$(usex octave)"
		-DUSE_MPI="$(usex test "$(usex mpi)")"
		-DUSE_OPENMP="$(usex openmp)"
		-DCMAKE_BUILD_STATIC_LIBS="no"
	)

	if use cuda; then
		cuda_add_sandbox -w

		mycmakeargs+=(
			-DCMAKE_CUDA_FLAGS="-Xcudafe \"--diag_suppress=partial_override\""
		)
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
	# some fail when run in parallel
	cmake_src_test -j1
}

src_install() {
	cmake_src_install

	# bug 795828; mpicc voluntarily adds some runpaths
	if use mpi; then
		chrpath -d "${ED}/usr/bin/flann_mpi_"{client,server} || die
	fi
}
