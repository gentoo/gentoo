# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="${WORKDIR}/${P}_build"

# oneDNN has its own FindBLAS.cmake file to find MKL (in a non-standard way).
# Removing of CMake modules is disabled.
CMAKE_REMOVE_MODULES_LIST=( none )

# There is additional sphinx documentation but we are missing dependency doxyrest.
inherit cmake docs multiprocessing toolchain-funcs

DESCRIPTION="oneAPI Deep Neural Network Library"
HOMEPAGE="https://github.com/oneapi-src/oneDNN"
SRC_URI="https://github.com/oneapi-src/oneDNN/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test mkl cblas static-libs +openmp"

RESTRICT="!test? ( test )"

DEPEND="
	mkl? ( sci-libs/mkl )
	cblas? ( !mkl? ( virtual/cblas ) )
"
RDEPEND="${DEPEND}"
BDEPEND="
	openmp? (
		|| (
			sys-devel/gcc[openmp]
			sys-devel/clang-runtime[openmp]
		)
	)
"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	if ! use openmp ; then
		ewarn "WARNING: oneDNN is being built with sequential runtime."
		ewarn "Proceeding might lead to highly sub-optimal performance."
		ewarn "Conside enabling \"openmp\" USE flag."
	fi

	local mycmakeargs=(
		-DDNNL_LIBRARY_TYPE=$(usex static-libs STATIC SHARED)
		-DDNNL_CPU_RUNTIME=$(usex openmp OMP SEQ)
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
		-DDNNL_ENABLE_PRIMITIVE_CPU_ISA=ALL
		-DONEDNN_ENABLE_GEMM_KERNELS_ISA=ALL
		-Wno-dev
	)

	if use mkl ; then
		if [ -e "${EPREFIX}"/opt/intel/oneapi/mkl/latest/env/vars.sh ]; then
			source "${EPREFIX}"/opt/intel/oneapi/mkl/latest/env/vars.sh || die
		else
			# bug 923109: sci-libs/mkl-2020.4.304 has no vars.sh, configure it manually
			export CPATH="${EPREFIX}"/usr/include/mkl
			export MKLROOT="${EPREFIX}"/usr
		fi

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

src_test() {
	local CMAKE_SKIP_TESTS=(
		# Crashes in sandbox (see #922886 and #923013);
		# waits for sys-apps/sandbox-2.39 release and stabilization.
		test_graph_unit_interface
		test_graph_unit_dnnl_layout_propagator
		test_graph_unit_dnnl_op_executable
		test_graph_unit_utils
	)

	if use openmp ; then
		# Don't run tests in parallel, each test is already parallelized
		OMP_NUM_THREADS=$(makeopts_jobs) cmake_src_test -j1
	else
		cmake_src_test
	fi
}
