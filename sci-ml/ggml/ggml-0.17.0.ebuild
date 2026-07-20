# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=7.2
inherit cmake rocm toolchain-funcs

DESCRIPTION="Tensor library for machine learning"
HOMEPAGE="https://ggml.ai/"
SRC_URI="https://github.com/ggml-org/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

X86_CPU_FLAGS=(
	avx
	avx_vnni
	avx2
	avx512bw
	avx512f
	avx512vbmi
	avx512_vnni
	bmi2
	fma3
	f16c
	sse4_2
)
CPU_FLAGS=( "${X86_CPU_FLAGS[@]/#/cpu_flags_x86_}" )
IUSE="${CPU_FLAGS[*]} openmp rocm test vulkan"

REQUIRED_USE="rocm? ( ${ROCM_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

# Should be >=sci-libs/hipBLAS-${ROCM_VERSION}[${ROCM_USEDEP}]
# But pkgcheck can't elaborate that
RDEPEND="
	vulkan? ( media-libs/vulkan-loader )
	rocm? (
		>=dev-util/hip-${ROCM_VERSION}
		>=sci-libs/hipBLAS-${ROCM_VERSION}
	)
"
DEPEND="${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"
BDEPEND="vulkan? ( media-libs/shaderc )"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DGGML_BACKEND_DL=OFF
		-DGGML_BUILD_EXAMPLES=OFF
		-DGGML_NATIVE=OFF
		-DGGML_HIP_MMQ_MFMA=OFF

		# CPU Flags
		-DGGML_AVX=$(usex cpu_flags_x86_avx)
		-DGGML_AVX_VNNI=$(usex cpu_flags_x86_avx_vnni)
		-DGGML_AVX2=$(usex cpu_flags_x86_avx2)
		-DGGML_AVX512_VBMI=$(usex cpu_flags_x86_avx512vbmi)
		-DGGML_AVX512_VNNI=$(usex cpu_flags_x86_avx512_vnni)
		-DGGML_BMI2=$(usex cpu_flags_x86_bmi2)
		-DGGML_FMA=$(usex cpu_flags_x86_fma3)
		-DGGML_F16C=$(usex cpu_flags_x86_f16c)
		-DGGML_SSE42=$(usex cpu_flags_x86_sse4_2)

		-DGGML_OPENMP=$(usex openmp)
		-DGGML_HIP=$(usex rocm)
		-DGGML_VULKAN=$(usex vulkan)

		-DGGML_BUILD_TESTS=$(usex test)
	)

	# Enable AVX512 if ANY of the avx512 flags are present
	if use cpu_flags_x86_avx512f || use cpu_flags_x86_avx512bw; then
		mycmakeargs+=( -DGGML_AVX512=ON )
	else
		mycmakeargs+=( -DGGML_AVX512=OFF )
	fi

	cmake_src_configure
}
