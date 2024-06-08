# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake cuda toolchain-funcs

DESCRIPTION="Fast approximate nearest neighbor searches in high dimensional spaces"
HOMEPAGE="https://github.com/flann-lib/flann"
SRC_URI="https://github.com/flann-lib/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="cuda doc examples mpi octave openmp"

BDEPEND="
	app-arch/unzip
	doc? ( dev-tex/latex2html )
	mpi? ( app-admin/chrpath )
"
DEPEND="
	app-arch/lz4:=
	cuda? ( >=dev-util/nvidia-cuda-toolkit-5.5 )
	mpi? (
		dev-libs/boost:=[mpi]
		sci-libs/hdf5:=[mpi=]
	)
	octave? ( >=sci-mathematics/octave-3.6.4-r1:= )
"
RDEPEND="${DEPEND}"
# TODO:
# readd dependencies for test suite,
# requires multiple ruby dependencies

PATCHES=(
	# "${FILESDIR}"/${PN}-1.9.1-cmake-3.11{,-1}.patch # bug 678030
	# "${FILESDIR}"/${PN}-1.9.1-cuda-9.patch
	# "${FILESDIR}"/${PN}-1.9.1-system-lz4.patch # bug 681898
	# "${FILESDIR}"/${PN}-1.9.1-system-lz4-pkgconfig.patch # bug 827263
	"${FILESDIR}"/${PN}-1.9.1-build-oct-rather-than-mex-files-for-octave.patch # bug 830424
	"${FILESDIR}"/${PN}-1.9.2-asio-boost187.patch
	"${FILESDIR}"/${PN}-1.9.2-boost-config.patch
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

	use cuda && cuda_src_prepare

	cmake_src_prepare
}

src_configure() {
	# append-cxxflags -std=c++17

	# python bindings are split off into dev-python/pyflann
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=17
		-DBUILD_C_BINDINGS=ON
		-DBUILD_PYTHON_BINDINGS=OFF
		-DPYTHON_EXECUTABLE=python3.12
		-DBUILD_CUDA_LIB="$(usex cuda)"
		-DBUILD_EXAMPLES="$(usex examples)"
		-DBUILD_DOC="$(usex doc)"
		-DBUILD_TESTS=OFF
		-DBUILD_MATLAB_BINDINGS="$(usex octave)"
		-DUSE_MPI="$(usex mpi)"
		-DUSE_OPENMP="$(usex openmp)"
	)

	# einfo "NVCCFLAGS ${NVCCFLAGS}"
	use cuda && mycmakeargs+=(
		# -DCUDA_NVCC_FLAGS="${NVCCFLAGS} --linker-options \"-arsch\""
		-DCUDA_NVCC_FLAGS="-ccbin /usr/x86_64-pc-linux-gnu/gcc-bin/13/g++"
	)
	use doc && mycmakeargs+=( -DDOCDIR="share/doc/${PF}" )

	cmake_src_configure
}

src_install() {
	cmake_src_install
	find "${ED}" -name 'lib*.a' -delete || die

	# bug 795828; mpicc volunterely adds some runpaths
	if use mpi; then
		chrpath -d "${ED}/usr/bin/flann_mpi_"{client,server} || die
	fi
}
