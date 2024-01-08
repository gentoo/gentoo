# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="${WORKDIR}/${P}_build"

# oneDNN has its own FindBLAS.cmake file to find MKL (in a non-standard way).
# Removing of CMake modules is disabled.
CMAKE_REMOVE_MODULES_LIST=( none )

# There is additional sphinx documentation but we are missing dependency doxyrest.
inherit cmake docs

DESCRIPTION="oneAPI Deep Neural Network Library"
HOMEPAGE="https://github.com/oneapi-src/oneDNN"
SRC_URI="https://github.com/oneapi-src/oneDNN/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test cpu_flags_x86_avx512f cpu_flags_x86_avx2 cpu_flags_x86_sse4_1 mkl cblas static-libs"

RESTRICT="!test? ( test )"

DEPEND="
	mkl? ( sci-libs/mkl )
	cblas? ( !mkl? ( virtual/cblas ) )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DDNNL_LIBRARY_TYPE=$(usex static-libs STATIC SHARED)
		-DDNNL_CPU_RUNTIME=OMP
		-DDNNL_GPU_RUNTIME=NONE
		-DDNNL_BUILD_EXAMPLES=OFF
		-DDNNL_BUILD_TESTS="$(usex test)"
		-DDNNL_ENABLE_CONCURRENT_EXEC=OFF
		-DDNNL_ENABLE_JIT_PROFILING=ON
		-DDNNL_ENABLE_ITT_TASKS=ON
		-DDNNL_ENABLE_PRIMITIVE_CACHE=ON
		-DDNNL_ENABLE_MAX_CPU_ISA=ON
		-DDNNL_ENABLE_CPU_ISA_HINTS=ON
		-DDNNL_ENABLE_WORKLOAD=TRAINING
		-DDNNL_ENABLE_PRIMITIVE=ALL
		-DDNNL_ENABLE_PRIMITIVE_GPU_ISA=ALL
		-DDNNL_EXPERIMENTAL=OFF
		-DDNNL_VERBOSE=ON
		-DDNNL_DEV_MODE=OFF
		-DDNNL_AARCH64_USE_ACL=OFF
		-DDNNL_GPU_VENDOR=INTEL
		-DDNNL_LIBRARY_NAME=dnnl
		-DONEDNN_BUILD_GRAPH=ON
		-DONEDNN_ENABLE_GRAPH_DUMP=OFF
		-DONEDNN_EXPERIMENTAL_GRAPH_COMPILER_BACKEND=OFF
		-Wno-dev
	)

	local isa="ALL"

	if use cpu_flags_x86_avx512f ; then
		isa="AVX512"
	elif use cpu_flags_x86_avx2; then
		isa="AVX2"
	elif use cpu_flags_x86_sse4_1; then
		isa="SSE41"
	else
		ewarn "WARNING: oneDNN is being built with for all ISA."
		ewarn "These may cause runtime issues CPUs that are not supported by oneDNN."
		ewarn ""
		ewarn "To configure oneDNN with ISA that is optimal for your CPU,"
		ewarn "set CPU_FLAGS_X86 in your make.conf, and re-emerge oneDNN."
		ewarn ""
		ewarn "See the list of supported CPUs at"
		ewarn "https://github.com/oneapi-src/oneDNN?tab=readme-ov-file#system-requirements"
		ewarn "For CPU_FLAGS_X86 documentation visit https://wiki.gentoo.org/wiki/CPU_FLAGS_*"
	fi

	mycmakeargs+=( -DDNNL_ENABLE_PRIMITIVE_CPU_ISA="${isa}" -DONEDNN_ENABLE_GEMM_KERNELS_ISA="${isa}" )

	if use mkl ; then
		source /opt/intel/oneapi/mkl/latest/env/vars.sh
		mycmakeargs+=( -DDNNL_BLAS_VENDOR=MKL )
	elif use cblas; then
		mycmakeargs+=( -DDNNL_BLAS_VENDOR=ANY -DBLA_VENDOR=Generic -DBLAS_LIBRARIES=-lcblas )
	else
		mycmakeargs+=( -DDNNL_BLAS_VENDOR=NONE )
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	docs_compile
}

src_install() {
	cmake_src_install

	# Correct docdir
	mv "${ED}/usr/share/doc/dnnl"* "${ED}/usr/share/doc/${PF}" || die
}
