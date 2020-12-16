# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake cuda toolchain-funcs

MY_PV="$(ver_rs "1-3" '_')"
DESCRIPTION="An Open-Source subdivision surface library"
HOMEPAGE="https://graphics.pixar.com/opensubdiv/docs/intro.html"
SRC_URI="https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

# Modfied Apache-2.0 license, where section 6 has been replaced.
# See for example CMakeLists.txt for details.
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuda examples opencl openmp ptex tbb test tutorials"

PATCHES=(
	"${FILESDIR}/${PN}-3.3.0-use-gnuinstalldirs.patch"
	"${FILESDIR}/${P}-install-tutorials-into-bin.patch"
)

RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	media-libs/glew:=
	media-libs/glfw:=
	x11-libs/libXinerama
	cuda? ( dev-util/nvidia-cuda-toolkit:* )
	opencl? ( virtual/opencl )
	ptex? ( media-libs/ptex )
"
DEPEND="
	${RDEPEND}
	tbb? ( dev-cpp/tbb )
"
S="${WORKDIR}/OpenSubdiv-${MY_PV}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake_src_prepare
	use cuda && cuda_add_sandbox
}

src_configure() {
	# GLTESTS are disabled as portage is unable to open a display during test phase
	local mycmakeargs=(
		-DGLEW_LOCATION="${EPREFIX}/usr/$(get_libdir)"
		-DGLFW_LOCATION="${EPREFIX}/usr/$(get_libdir)"
		-DNO_CLEW=ON
		-DNO_CUDA=$(usex !cuda)
		-DNO_DOC=ON
		-DNO_EXAMPLES=$(usex !examples)
		-DNO_GLTESTS=ON
		-DNO_OMP=$(usex !openmp)
		-DNO_OPENCL=$(usex !opencl)
		-DNO_PTEX=$(usex !ptex)
		-DNO_REGRESSION=$(usex !test)
		-DNO_TBB=$(usex !tbb)
		-DNO_TESTS=$(usex !test)
		-DNO_TUTORIALS=$(usex !tutorials)
	)

	if use cuda; then
		if [[ *$(gcc-version)* != $(cuda-config -s) ]]; then
			ewarn "Opensubdiv is being built with Nvidia CUDA support."
			ewarn "Your default compiler version $(gcc-version) is not supported by the currently installed CUDA."
			ewarn ""
			ewarn "Your CUDA version supports $(cuda_gccdir)/$(tc-getCC)"
			ewarn ""
			ewarn "If the build fails try changing the compiler version using gcc-config"
			ewarn "or overriding PATH, CC and CXX for this package using package.env"
		fi

		if [[ -z "${OSD_CUDA_COMPUTE_CAPABILITIES}" ]]; then
			ewarn "Opensubdiv is being built with CUDA 2.0 support, which was deprecated in"
			ewarn "nvidia-cuda-utils-9. This may also not be optimal for your GPU."
			ewarn ""
			ewarn "To select the optimal CUDA support for your GPU,"
			ewarn "set OSD_CUDA_COMPUTE_CAPABILITIES in your make.conf and re-emerge opensubdiv"
			ewarn "For example, to use CUDA capability 3.5, add OSD_CUDA_COMPUTE_CAPABILITIES=sm_35"
			ewarn "or to use JIT compilation, add OSD_CUDA_COMPUTE_CAPABILITIES=compute_35"
			ewarn ""
			ewarn "You can look up your GPU's CUDA compute capability at https://developer.nvidia.com/cuda-gpus"
			ewarn "or by running /opt/cuda/extras/demo_suite/deviceQuery | grep 'CUDA Capability'"
			mycmakeargs+=( -DOSD_CUDA_NVCC_FLAGS="--gpu-architecture;compute_20" )
		else
			mycmakeargs+=( -DOSD_CUDA_NVCC_FLAGS="--gpu-architecture;${OSD_CUDA_COMPUTE_CAPABILITIES}" )
		fi
	fi

	cmake_src_configure
}

src_compile() {
	# fails with building cuda kernels when using multiple jobs
	cmake_src_compile -j1

}
