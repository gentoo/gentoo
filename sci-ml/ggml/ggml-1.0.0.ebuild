# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
ROCM_VERSION=7.2  # controls AMDGPU_TARGETS
ROCM_MIN_VERSION=6.1  # src/ggml-hip/CMakeList.txt

inherit cmake cuda flag-o-matic python-any-r1 rocm toolchain-funcs

DESCRIPTION="Tensor library for machine learning"
HOMEPAGE="https://ggml.ai/"
SRC_URI="https://github.com/ggml-org/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64"

X86_CPU_FLAGS=(
	amx_bf16
	amx_int8
	amx_tile
	avx
	avx_vnni
	avx2
	avx512_bf16
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
IUSE="blas flexiblas ${CPU_FLAGS[*]} cuda opencl openmp rocm test vulkan"

REQUIRED_USE="rocm? ( ${ROCM_REQUIRED_USE} )"

unset X86_CPU_FLAGS CPU_FLAGS

RESTRICT="!test? ( test )"

# Should be >=sci-libs/hipBLAS-${ROCM_VERSION}[${ROCM_USEDEP}]
# But pkgcheck can't elaborate that
RDEPEND="
	blas? ( virtual/cblas[flexiblas=] )
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	opencl? (
		dev-libs/opencl-icd-loader
	)
	vulkan? ( media-libs/vulkan-loader )
	rocm? (
		>=dev-util/hip-${ROCM_MIN_VERSION}:=
		>=sci-libs/hipBLAS-${ROCM_MIN_VERSION}:=
		>=sci-libs/rocBLAS-${ROCM_MIN_VERSION}:=
	)
"
DEPEND="${RDEPEND}
	opencl? ( dev-util/opencl-headers )
	vulkan? ( dev-util/vulkan-headers )
"
BDEPEND="
	opencl? ( ${PYTHON_DEPS} )
	vulkan? ( media-libs/shaderc )
"

DOCS=( AUTHORS CONTRIBUTING.md docs/gguf.md README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-0.28.0-llvm-23.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	if use opencl; then
		python-any-r1_pkg_setup
	fi

	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake_src_prepare

	if use cuda; then
		cuda_src_prepare
		filter-lto #bug 983121
	fi
}

src_configure() {
	local mycmakeargs=(
		-DGGML_BACKEND_DL=OFF
		-DGGML_BUILD_EXAMPLES=OFF
		-DGGML_NATIVE=OFF
		-DGGML_HIP_MMQ_MFMA=OFF
		-DGGML_LTO=OFF # only adds flags
		-DGGML_CCACHE=OFF

		# CPU Flags
		-DGGML_AMX_BF16=$(usex cpu_flags_x86_amx_bf16)
		-DGGML_AMX_INT8=$(usex cpu_flags_x86_amx_int8)
		-DGGML_AMX_TILE=$(usex cpu_flags_x86_amx_tile)
		-DGGML_AVX=$(usex cpu_flags_x86_avx)
		-DGGML_AVX_VNNI=$(usex cpu_flags_x86_avx_vnni)
		-DGGML_AVX2=$(usex cpu_flags_x86_avx2)
		-DGGML_AVX512_BF16=$(usex cpu_flags_x86_avx512_bf16)
		-DGGML_AVX512_VBMI=$(usex cpu_flags_x86_avx512vbmi)
		-DGGML_AVX512_VNNI=$(usex cpu_flags_x86_avx512_vnni)
		-DGGML_BMI2=$(usex cpu_flags_x86_bmi2)
		-DGGML_FMA=$(usex cpu_flags_x86_fma3)
		-DGGML_F16C=$(usex cpu_flags_x86_f16c)
		-DGGML_SSE42=$(usex cpu_flags_x86_sse4_2)

		-DGGML_BLAS=$(usex blas)
		-DGGML_CUDA=$(usex cuda)
		-DGGML_HIP=$(usex rocm)
		-DGGML_OPENMP=$(usex openmp)
		-DGGML_VULKAN=$(usex vulkan)

		-DGGML_BUILD_TESTS=$(usex test)
	)

	# Enable AVX512 if ANY of the avx512 flags are present
	if use cpu_flags_x86_avx512f || use cpu_flags_x86_avx512bw; then
		mycmakeargs+=( -DGGML_AVX512=ON )
	else
		mycmakeargs+=( -DGGML_AVX512=OFF )
	fi

	if use blas; then
		if use flexiblas; then
			mycmakeargs+=( -DGGML_BLAS_VENDOR=FlexiBLAS )
		else
			mycmakeargs+=(
				-DGGML_BLAS_VENDOR=Generic
				# https://cmake.org/cmake/help/latest/module/FindBLAS.html
				-DBLA_PREFER_PKGCONFIG=ON
				-DBLA_PKGCONFIG_BLAS=cblas
			)
		fi
	fi

	if use cuda; then
		cuda_add_sandbox -w
		addpredict "/dev/char/"
		cuda_sanitize
		mycmakeargs+=(
			-DCMAKE_CUDA_FLAGS="${NVCCFLAGS}"
		)
	fi

	if use rocm; then
		# Changing compiler with rocm_use_{hipcc,clang} is not necessary
		# Pass HIP compatible flags using dedicated CMake variables
		mycmakeargs+=(
			-DGPU_TARGETS=$(get_amdgpu_flags)
			-DCMAKE_HIP_FLAGS="$(test-flags-HIPCXX ${CXXFLAGS})"
			# cmake.eclass clears per-build-type flags for C/CXX only; drop CMake's "-O2 -g -DNDEBUG" for HIP
			-DCMAKE_HIP_FLAGS_${CMAKE_BUILD_TYPE^^}=
		)
	fi

	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=()
	if use rocm; then
		check_amdgpu
		if use amdgpu_targets_gfx1031; then  # raise CUDA errors
			CMAKE_SKIP_TESTS+=(
				test-backend-ops
				test-opt
			)
		fi
	fi
	cmake_src_test
}
