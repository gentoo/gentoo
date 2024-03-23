# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake cuda toolchain-funcs

MY_PV="$(ver_rs "1-3" '_')"

DESCRIPTION="An Open-Source subdivision surface library"
HOMEPAGE="https://graphics.pixar.com/opensubdiv/docs/intro.html"
SRC_URI="https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OpenSubdiv-${MY_PV}"

# Modfied Apache-2.0 license, where section 6 has been replaced.
# See for example CMakeLists.txt for details.
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="cuda examples opencl openmp ptex tbb test tutorials"
RESTRICT="!test? ( test )"

RDEPEND="
	examples? (
		media-libs/glew:=
		media-libs/glfw:=
		x11-libs/libXinerama
	)
	cuda? ( dev-util/nvidia-cuda-toolkit:* )
	opencl? ( virtual/opencl )
	ptex? ( media-libs/ptex )
"
DEPEND="
	${RDEPEND}
	tbb? ( dev-cpp/tbb:= )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.3.0-use-gnuinstalldirs.patch"
	"${FILESDIR}/${PN}-3.4.3-install-tutorials-into-bin.patch"
	"${FILESDIR}/${PN}-3.4.4-tbb-2021.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake_src_prepare

	use cuda && cuda_src_prepare
}

src_configure() {
	# GLTESTS are disabled as portage is unable to open a display during test phase
	# TODO: virtx work?
	local mycmakeargs=(
		-DGLEW_LOCATION="${ESYSROOT}/usr/$(get_libdir)"
		-DGLFW_LOCATION="${ESYSROOT}/usr/$(get_libdir)"
		-DNO_CLEW=ON
		-DNO_CUDA=$(usex !cuda)
		# Docs needed Python 2 so disabled
		# bug #815172
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
		# old cmake CUDA module doesn't use environment variable to initialize flags
		mycmakeargs+=( -DCUDA_NVCC_FLAGS="${NVCCFLAGS}" )

		# check if user provided --gpu-architecture/-arch flag and prevent cmake from overriding it if so
		for f in ${NVCCFLAGS}; do
			if [[ ${f} == -arch* || ${f} == --gpu-architecture* ]]; then
				mycmakeargs+=( -DOSD_CUDA_NVCC_FLAGS="" )
				break
			fi
		done
	fi

	cmake_src_configure
}

src_test() {
	CMAKE_SKIP_TESTS=(
		"far_tutorial_1_2"
	)

	cmake_src_test
}

src_install() {
	cmake_src_install

	rm -f "${ED}/usr/$(get_libdir)/libosdCPU.a" || die
	if use cuda || use opencl ; then
		rm -f "${ED}/usr/$(get_libdir)/libosdGPU.a" || die
	fi
	if use test; then
		rm -f \
			"${ED}/usr/bin/bfr_evaluate" \
			"${ED}/usr/bin/far_perf" \
			"${ED}/usr/bin/far_regression" \
			"${ED}/usr/bin/hbr_baseline" \
			"${ED}/usr/bin/hbr_regression" \
			"${ED}/usr/bin/osd_regression" \
			|| die
	fi
}
