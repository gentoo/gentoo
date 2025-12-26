# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {19..21} )
LLVM_OPTIONAL="clang-cuda"
FORTRAN_NEEDED="test"
inherit cmake cuda flag-o-matic fortran-2 llvm-r2 toolchain-funcs virtualx

DESCRIPTION="C++ template library for linear algebra"
HOMEPAGE="https://eigen.tuxfamily.org/index.php?title=Main_Page"

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/lib${PN}/${PN}.git"
	if [[ ${PV} = 3.4.9999* ]] ; then
		EGIT_BRANCH="3.4"
	fi
else
	SRC_URI="
		https://gitlab.com/lib${PN}/${PN}/-/archive/${PV}/${P}.tar.bz2
		https://gitlab.com/libeigen/eigen/-/commit/0295f81a835ef69e2bacd9e75ab5782eca398720.patch -> ${P}_p1.patch
		https://gitlab.com/libeigen/eigen/-/commit/28ded8800c26864e537852658428ab44c8399e87.patch -> ${P}_p2.patch
		test? ( lapack? ( https://downloads.tuxfamily.org/${PN}/lapack_addons_3.4.1.tgz -> ${PN}-lapack_addons-3.4.1.tgz ) )
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"
fi

LICENSE="MPL-2.0"
SLOT="3/$(ver_cut 1-2)"

# The following lines are shamelessly stolen from ffmpeg-9999.ebuild with modifications
ARM_CPU_FEATURES=(
	neon:NEON
)
PPC_CPU_FEATURES=(
	altivec:ALTIVEC
	vsx:VSX
)
X86_CPU_FEATURES=(
	avx:AVX
	avx2:AVX2
	avx512f:AVX512
	avx512dq:AVX512DQ
	f16c:FP16C
	fma3:FMA
	popcnt:POPCNT
	sse:SSE
	sse2:SSE2
	sse3:SSE3
	ssse3:SSSE3
	sse4_1:SSE4_1
	sse4_2:SSE4_2
)
# MIPS_CPU_FEATURES=(
# 	msa:MSA
# )
# S390_CPU_FEATURES=(
# 	z13:Z13
# 	z14:Z14
# )

CPU_FEATURES_MAP=(
	"${ARM_CPU_FEATURES[@]/#/cpu_flags_arm_}"
	"${PPC_CPU_FEATURES[@]/#/cpu_flags_ppc_}"
	"${X86_CPU_FEATURES[@]/#/cpu_flags_x86_}"
	# "${MIPS_CPU_FEATURES[@]/#/cpu_flags_mips_}"
	# "${S390_CPU_FEATURES[@]/#/cpu_flags_s390_}"
)

IUSE_TEST_BACKENDS=(
	"adolc"
	"boost"
	"cholmod"
	"fftw"
	"klu"
	"opengl"
	"openmp"
	"pastix"
	"sparsehash"
	"spqr"
	"superlu"
	"umfpack"
)

IUSE="${CPU_FEATURES_MAP[*]%:*} clang-cuda cuda hip debug doc lapack mathjax test ${IUSE_TEST_BACKENDS[*]}" #zvector

REQUIRED_USE="
	test? (
		|| ( ${IUSE_TEST_BACKENDS[*]} )
		clang-cuda? ( ${LLVM_REQUIRED_USE} )
	)
"

# Tests failing again because of compiler issues; bugs #932646, #943401
RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		app-text/doxygen[dot]
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		mathjax? ( dev-libs/mathjax )
	)
	test? ( virtual/pkgconfig )
"

# METIS
# MPREAL
# dev-libs/mpfr:0
# dev-libs/gmp:0

TEST_BACKENDS="
		boost? ( dev-libs/boost )
		adolc? ( sci-libs/adolc[sparse] )
		cholmod? ( sci-libs/cholmod:= )
		fftw? ( sci-libs/fftw )
		spqr? ( sci-libs/spqr )
		klu? ( sci-libs/klu )
		opengl? (
			media-libs/freeglut
			media-libs/glew
			media-libs/libglvnd
		)
		pastix? ( sci-libs/pastix[-mpi] )
		sparsehash? (
			amd64? ( dev-cpp/sparsehash )
			arm64? ( dev-cpp/sparsehash )
			ppc64? ( dev-cpp/sparsehash )
			x86?   ( dev-cpp/sparsehash )
		)
		superlu? ( sci-libs/superlu )
		umfpack? ( sci-libs/umfpack )
"
DEPEND="
	test? (
		cuda? (
			!clang-cuda? (
				dev-util/nvidia-cuda-toolkit
			)
			clang-cuda? (
				$(llvm_gen_dep '
					llvm-core/clang:${LLVM_SLOT}[llvm_targets_NVPTX]
					llvm-runtimes/clang-runtime:${LLVM_SLOT}[offload,openmp?]
					=llvm-runtimes/offload-${LLVM_SLOT}*[llvm_targets_NVPTX]
				')
			)
		)
		hip? ( dev-util/hip )
		lapack? ( virtual/lapacke )
		${TEST_BACKENDS}
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-3.4.0-doc-nocompress.patch" # bug 830064
	"${FILESDIR}/${PN}-3.4.0-buildstring.patch"
	"${FILESDIR}/${PN}-3.4.1-cxxstandard-17.patch"

	"${FILESDIR}/${PN}-3.4.0-c++-20.patch"

	"${DISTDIR}/${P}_p1.patch"
	"${DISTDIR}/${P}_p2.patch"
)

# TODO should be in cuda.eclass
cuda_set_CUDAHOSTCXX() {
	local compiler
	tc-is-gcc && compiler="gcc"
	tc-is-clang && compiler="clang"
	[[ -z "$compiler" ]] && die "no compiler specified"

	local package="sys-devel/${compiler}"
	local version="${package}"
	local CUDAHOSTCXX_test
	while
		CUDAHOSTCXX="${CUDAHOSTCXX_test}"
		version=$(best_version "${version}")
		if [[ -z "${version}" ]]; then
			if [[ -z "${CUDAHOSTCXX}" ]]; then
				die "could not find supported version of ${package}"
			fi
			break
		fi
		CUDAHOSTCXX_test="$(
			which "${compiler}-$(echo "${version}" | grep -oP "(?<=${package}-)[0-9]*")"
		)"
		version="<${version}"
	do ! echo "int main(){}" | nvcc "-ccbin ${CUDAHOSTCXX_test}" - -x cu &>/dev/null; done

	export CUDAHOSTCXX
	echo "${CUDAHOSTCXX}"
}

pkg_setup() {
	use test && use cuda && use clang-cuda && llvm-r2_pkg_setup
}

src_unpack() {
	if [[ ${PV} = *9999* ]] ; then
		git-r3_src_unpack
	else
		unpack "${P}.tar.bz2"

		if use test && use lapack; then
			cd "${S}/lapack" || die
			unpack "${PN}-lapack_addons-3.4.1.tgz"
		fi
	fi
}

src_prepare() {
	sed \
		-e "/add_subdirectory(bench\/spbench/s/^/#DONOTCOMPILE /g" \
		-e "/add_subdirectory(demos/s/^/#DONOTCOMPILE /g" \
		-i CMakeLists.txt || die

	rm -r bench demos || die

	# run patches here as we patch in test/
	cmake_src_prepare

	if ! use test; then
		sed \
			-e "/add_subdirectory(test/s/^/#DONOTCOMPILE /g" \
			-e "/add_subdirectory(scripts/s/^/#DONOTCOMPILE /g" \
			-e "/add_subdirectory(failtest/s/^/#DONOTCOMPILE /g" \
			-e "/add_subdirectory(blas/s/^/#DONOTCOMPILE /g" \
			-e "/add_subdirectory(lapack/s/^/#DONOTCOMPILE /g" \
			-i CMakeLists.txt || die

		# scripts
		# scripts/cdashtesting.cmake.in
		rm -r test failtest blas lapack || die
	fi
}

src_configure() {
	# EIGEN_BUILD_TESTING # "Enable creation of Eigen tests." ${BUILD_TESTING})
	# EIGEN_LEAVE_TEST_IN_ALL_TARGET # "Leaves tests in the all target, needed by ctest for automatic building." OFF)
	# EIGEN_BUILD_BLAS # "Toggles the building of the Eigen Blas library" ${PROJECT_IS_TOP_LEVEL})
	# EIGEN_BUILD_LAPACK # "Toggles the building of the included Eigen LAPACK library" ${PROJECT_IS_TOP_LEVEL})
	# EIGEN_BUILD_BTL # "Build benchmark suite" OFF)
	# EIGEN_BUILD_SPBENCH # "Build sparse benchmark suite" OFF)
	# EIGEN_BUILD_DOC # "Enable creation of Eigen documentation" ${EIGEN_BUILD_DOC_DEFAULT})
	# EIGEN_BUILD_DEMOS # "Toggles the building of the Eigen demos" ${PROJECT_IS_TOP_LEVEL})
	# EIGEN_BUILD_PKGCONFIG # "Build pkg-config .pc file for Eigen" ${PROJECT_IS_TOP_LEVEL})
	# EIGEN_BUILD_CMAKE_PACKAGE # "Enables the creation of EigenConfig.cmake and related files" ${PROJECT_IS_TOP_LEVEL})
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS="yes"
		-DBUILD_TESTING="$(usex test)"

		-DEIGEN_BUILD_DOC="$(usex doc)" # Enable creation of Eigen documentation
		-DEIGEN_BUILD_PKGCONFIG="yes" # Build pkg-config .pc file for Eigen
	)
	if use doc || use test; then
		mycmakeargs+=(
			# needs Qt4
			-DEIGEN_TEST_NOQT="yes" # Disable Qt support in unit tests
		)
	fi

	if use doc; then
		mycmakeargs+=(
			-DEIGEN_DOC_USE_MATHJAX="$(usex mathjax)" # Use MathJax for rendering math in HTML docs
			-DEIGEN_INTERNAL_DOCUMENTATION=no # Build internal documentation
		)
	fi

	if use test; then
		# bug 878987
		filter-lto

		mycmakeargs+=(
			# the OpenGL testsuite is extremely brittle, bug #712808
			-DOpenGL_GL_PREFERENCE="GLVND"
			-DEIGEN_TEST_OPENGL="$(usex opengl)" # Enable OpenGL support in unit tests
			-DEIGEN_TEST_OPENMP="$(usex openmp)" # Enable/Disable OpenMP in tests/examples

			-DCMAKE_DISABLE_FIND_PACKAGE_MPREAL=ON

			-DEIGEN_TEST_CXX11="yes"

			# -DEIGEN_TEST_CUSTOM_CXX_FLAGS= # Additional compiler flags when compiling unit tests.
			# -DEIGEN_TEST_CUSTOM_LINKER_FLAGS= # Additional linker flags when linking unit tests.
			# -DEIGEN_TEST_BUILD_FLAGS= # Options passed to the build command of unit tests

			# -DEIGEN_BUILD_BTL=yes # Build benchmark suite

			-DEIGEN_TEST_BUILD_DOCUMENTATION="$(usex doc)" # Test building the doxygen documentation

			# -DEIGEN_COVERAGE_TESTING=no # Enable/disable gcov
			# -DEIGEN_CTEST_ERROR_EXCEPTION= # Regular expression for build error messages to be filtered out
			# -DEIGEN_DEBUG_ASSERTS=no # Enable advanced debugging of assertions
			# -DEIGEN_NO_ASSERTION_CHECKING=no # Disable checking of assertions using exceptions
			# -DEIGEN_TEST_NO_EXCEPTIONS=no # Disables C++ exceptions
			# -DEIGEN_TEST_NO_EXPLICIT_ALIGNMENT=no # Disable explicit alignment (hence vectorization) in tests/examples
			# -DEIGEN_TEST_NO_EXPLICIT_VECTORIZATION=no # Disable explicit vectorization in tests/examples

			# -DEIGEN_DASHBOARD_BUILD_TARGET=buildtests # Target to be built in dashboard mode, default is buildtests

			# -DEIGEN_DEFAULT_TO_ROW_MAJOR=no # Use row-major as default matrix storage order

			# -DEIGEN_TEST_MATRIX_DIR=yes # Enable testing of realword sparse matrices contained in the specified path
			# -DEIGEN_TEST_MAX_SIZE=320 # Maximal matrix/vector size, default is 320
			# -DEIGEN_SPLIT_LARGE_TESTS=no # Split large tests into smaller executables
		)

		use !adolc      && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Adolc="TRUE" )
		use !boost      && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Boost="TRUE" )
		use !cholmod    && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_CHOLMOD="TRUE" )
		use !fftw       && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_FFTW="TRUE" )
		use !sparsehash && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_GoogleHash="TRUE" )
		use !klu        && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_KLU="TRUE" )
		use !opengl     && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_OpenGL="TRUE" )
		use !openmp     && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_OpenMP="TRUE" )
		use !pastix     && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_PASTIX="TRUE" )
		use !spqr       && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_SPQR="TRUE" )
		use !superlu    && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_SuperLU="TRUE" )
		use !umfpack    && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_UMFPACK="TRUE" )

		if use lapack; then
			mycmakeargs+=(
				-DEIGEN_ENABLE_LAPACK_TESTS=yes
				-DEIGEN_TEST_EXTERNAL_BLAS=yes # Use external BLAS library for testsuite
				-DCMAKE_DISABLE_FIND_PACKAGE_SuperLU=ON
			)
		fi

		if use arm; then
			mycmakeargs+=(
				-DEIGEN_TEST_NEON="$(usex cpu_flags_arm_neon)"
			)
		fi

		if use arm64; then
			mycmakeargs+=(
				-DEIGEN_TEST_NEON64="$(usex cpu_flags_arm_neon)"
			)
		fi

		if use ppc || use ppc64; then
			mycmakeargs+=(
				-DEIGEN_TEST_ALTIVEC="$(usex cpu_flags_ppc_altivec)"
				-DEIGEN_TEST_VSX="$(usex cpu_flags_ppc_vsx)"
			)
		fi

		if use amd64 || use x86; then
			mycmakeargs+=(
				# -DEIGEN_TEST_32BIT=no # Force generating 32bit code.
				# -DEIGEN_TEST_X87=no # Force using X87 instructions. Implies no vectorization.
				-DEIGEN_TEST_SSE2="$(usex cpu_flags_x86_sse2)"
				-DEIGEN_TEST_SSE3="$(usex cpu_flags_x86_sse3)"
				-DEIGEN_TEST_SSSE3="$(usex cpu_flags_x86_ssse3)"
				-DEIGEN_TEST_FMA="$(usex cpu_flags_x86_fma3)"
				-DEIGEN_TEST_SSE4_1="$(usex cpu_flags_x86_sse4_1)"
				-DEIGEN_TEST_SSE4_2="$(usex cpu_flags_x86_sse4_2)"
				-DEIGEN_TEST_AVX="$(usex cpu_flags_x86_avx)"
				-DEIGEN_TEST_F16C="$(usex cpu_flags_x86_f16c)"
				-DEIGEN_TEST_AVX2="$(usex cpu_flags_x86_avx2)"
				-DEIGEN_TEST_AVX512="$(usex cpu_flags_x86_avx512f)"
				-DEIGEN_TEST_AVX512DQ="$(usex cpu_flags_x86_avx512dq)"
			)
		fi

		if use mips; then
			mycmakeargs+=(
				# -DEIGEN_TEST_MSA=no # Enable/Disable MSA in tests/examples
			)
		fi

		if use s390; then
			mycmakeargs+=(
				# -DEIGEN_TEST_Z13=no # Enable/Disable S390X(zEC13) ZVECTOR in tests/examples
				# -DEIGEN_TEST_Z14=no # Enable/Disable S390X(zEC14) ZVECTOR in tests/examples
			)
		fi

		mycmakeargs+=(
			-DEIGEN_TEST_CUDA="$(usex cuda)" # Enable CUDA support in unit tests
			-DEIGEN_TEST_CUDA_CLANG="$(usex cuda "$(usex clang-cuda)")" # Use clang instead of nvcc to compile the CUDA tests

			-DEIGEN_TEST_HIP="$(usex hip)" # Add HIP support.

			# -DEIGEN_TEST_SYCL=no # Add Sycl support.
			# -DEIGEN_SYCL_TRISYCL=no # Use the triSYCL Sycl implementation (ComputeCPP by default).
		)

		if use cuda; then
			cuda_add_sandbox -w
			if use clang-cuda; then
				local llvm_prefix
				llvm_prefix="$(get_llvm_prefix -b)"
				export CC="${llvm_prefix}/bin/clang"
				export CXX="${llvm_prefix}/bin/clang++"
				# export LIBRARY_PATH="${ESYSROOT}/usr/$(get_libdir)"
				export LIBRARY_PATH="${llvm_prefix}/$(get_libdir)"
				mycmakeargs+=(
					-DCUDA_HOST_COMPILER="${llvm_prefix}/bin/clang++"
				)
			else
				cuda_set_CUDAHOSTCXX
				mycmakeargs+=(
					-DCUDA_HOST_COMPILER="${CUDAHOSTCXX}"
				)
			fi

			if [[ "${CUDA_VERBOSE}" == true ]]; then
				mycmakeargs+=(
					-DCUDA_VERBOSE_BUILD=yes
				)
				NVCCFLAGS+=" -v"
			fi

			export CUDAFLAGS="${NVCCFLAGS}"

			[[ -z "${CUDAARCHS}" ]] && einfo "trying to determine host CUDAARCHS"
			if use clang-cuda; then
				: "${CUDAARCHS:=$(nvptx-arch || die)}"
				CUDAARCHS="${CUDAARCHS//sm_/}"
			else
				: "${CUDAARCHS:=$(__nvcc_device_query || die )}"
			fi
			export CUDAARCHS

			mycmakeargs+=(
				-DEIGEN_CUDA_COMPUTE_ARCH="${CUDAARCHS}"
				-DEIGEN_CUDA_CXX_FLAGS="${NVCCFLAGS}"
				-DCUDA_USE_STATIC_CUDA_RUNTIME="yes"
			)
		fi
	fi

	cmake_src_configure
}

src_compile() {
	local targets=()

	if use test; then
		targets+=( buildtests )
		if ! use lapack; then
			targets+=( blas )
		fi

		# tests generate random data, which obviously fails for some seeds
		export EIGEN_SEED=712808
	fi

	# we add doc last to capture results for buildtests
	if use doc; then
		targets+=( doc )
		HTML_DOCS=( "${BUILD_DIR}/doc/html/." )
	fi

	if use doc || use test; then
		cmake_src_compile "${targets[@]}"
	fi
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		"^klu_support_1$" # (Subprocess aborted)
		"^klu_support_2$" # (Subprocess aborted)
		"^basicstuff_8$" # (Subprocess aborted)                 Official
		"^matrix_power_8$" # (Subprocess aborted)               Unsupported
		"^matrix_power_11$" # (Subprocess aborted)              Unsupported
		"^matrix_square_root_3$" # (Subprocess aborted)         Unsupported

		"^ref_8$" #  (Subprocess aborted)                        Official

		"^product_small_32$"           #  143 (Subprocess aborted)
		"^product_small_33$"           #  144 (Subprocess aborted)

		"^eigensolver_selfadjoint_13$" #  452 (Subprocess aborted) # Official

		"^cholmod_support_21$"         #  726 (Subprocess aborted)
		"^cholmod_support_22$"         #  727 (Subprocess aborted)

		"^NonLinearOptimization$"      #  930 (Subprocess aborted)
		"^openglsupport$"              #  990 (Failed)
		"^levenberg_marquardt$"        # 1020 (Subprocess aborted)
	)

	if use cuda ; then
		cuda_add_sandbox -w

		CMAKE_SKIP_TESTS+=(
			# "^cxx11_tensor_cast_float16_gpu$"
			# "^cxx11_tensor_gpu_5$"
		)
	fi

	if use lapack ; then
		CMAKE_SKIP_TESTS+=(
			# "^LAPACK-.*$"
		)
	fi

	local myctestargs=(
		# slowdowns?
		-j1 # otherwise breaks due to cmake reruns
	)

	virtx cmake_src_test
}
