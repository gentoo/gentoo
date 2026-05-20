# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {21..23} )
LLVM_OPTIONAL="cuda-clang"

PYTHON_COMPAT=( python3_{12..14} )

FORTRAN_NEEDED="no"

LAPACK_ADDONS_PV="3.4.1"

inherit cmake cuda flag-o-matic fortran-2 llvm-r2 python-any-r1 toolchain-funcs virtualx

DESCRIPTION="C++ template library for linear algebra"
HOMEPAGE="https://eigen.tuxfamily.org/index.php?title=Main_Page"

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/lib${PN}/${PN}.git"
	if [[ ${PV} = *.9999* ]] ; then
		EGIT_BRANCH="$(ver_cut 1-2)"
	fi
else
	SRC_URI="
		https://gitlab.com/lib${PN}/${PN}/-/archive/${PV}/${P}.tar.bz2
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"
fi

SRC_URI+="
	test? (
		lapack? (
			https://downloads.tuxfamily.org/${PN}/lapack_addons_${LAPACK_ADDONS_PV}.tgz
				-> ${PN}-lapack_addons-${LAPACK_ADDONS_PV}.tgz
		)
	)
"

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
	"metis"
	"opengl"
	"pastix"
	"pocketfft"
	"sparsehash"
	"spqr"
	"superlu"
	"umfpack"
)

IUSE="
	debug
	blas lapack
	${CPU_FEATURES_MAP[*]%:*}
	cuda cuda-clang hip
	doc mathjax
	openmp
	test ${IUSE_TEST_BACKENDS[*]}
"
# zvector

REQUIRED_USE="
	lapack? (
		blas
	)
	test? (
		|| ( ${IUSE_TEST_BACKENDS[*]} )
		cuda-clang? (
			!openmp
			${LLVM_REQUIRED_USE}
		)
	)
"

# Tests failing again because of compiler issues; bugs #932646, #943401
RESTRICT="!test? ( test )"
FORTRAN_DEPEND="virtual/fortran"

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
	test? (
		virtual/pkgconfig
		lapack? (
			${PYTHON_DEPS}
		)
		spqr? (
			cholmod? (
				blas? (
					lapack? (
						${FORTRAN_DEPEND}
					)
				)
			)
		)
		pastix? ( ${FORTRAN_DEPEND} )
	)
	blas? ( ${FORTRAN_DEPEND} )
	lapack? ( ${FORTRAN_DEPEND} )
"

TEST_BACKENDS="
		adolc? ( sci-libs/adolc[sparse] )
		boost? ( dev-libs/boost )
		cholmod? ( sci-libs/cholmod:=[cuda?] )
		fftw? ( sci-libs/fftw[openmp?] )
		klu? ( sci-libs/klu:= )
		metis? (
			sci-libs/metis[openmp?]
			sci-libs/pastix[metis]
		)
		opengl? (
			media-libs/freeglut
			media-libs/glew
			media-libs/libglvnd
		)
		pastix? (
			sci-libs/pastix[-mpi]
			|| (
				sci-libs/pastix[scotch]
				sci-libs/pastix[metis]
			)
		)
		pocketfft? ( dev-libs/pocketfft )
		sparsehash? (
			amd64? ( dev-cpp/sparsehash )
			arm64? ( dev-cpp/sparsehash )
			ppc64? ( dev-cpp/sparsehash )
			x86?   ( dev-cpp/sparsehash )
		)
		spqr? ( sci-libs/spqr:= )
		superlu? ( sci-libs/superlu:= )
		umfpack? ( sci-libs/umfpack:= )
"

DEPEND="
	test? (
		cuda? (
			!cuda-clang? (
				dev-util/nvidia-cuda-toolkit
			)
			cuda-clang? (
				$(llvm_gen_dep '
					llvm-core/clang:${LLVM_SLOT}
					llvm-runtimes/clang-runtime:${LLVM_SLOT}[llvm_targets_NVPTX,offload,openmp]
				')
			)
		)
		hip? ( dev-util/hip )
		!blas? (
			virtual/blas
			!lapack? (
				virtual/lapacke
			)
		)
		${TEST_BACKENDS}
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-3.4.0-doc-nocompress.patch" # bug 830064
	"${FILESDIR}/${PN}-3.4.0-buildstring.patch"

	"${FILESDIR}/${PN}-5.0.1-cmake-GNUInstallDirs.patch"
	"${FILESDIR}/${PN}-5.0.1-make-static-libs-optional.patch"

	"${FILESDIR}/${PN}-9999-Do-not-show-deprecated-CUDA-device-properties-for-CU.patch"
	"${FILESDIR}/${PN}-9999-product_threaded_dont_parallelize.patch"
)

# TODO should be in cuda.eclass
cuda_get_host_compiler() {
	if [[ -n "${NVCC_CCBIN}" ]]; then
		echo "${NVCC_CCBIN}"
		return
	fi

	if [[ -n "${CUDAHOSTCXX}" ]]; then
		echo "${CUDAHOSTCXX}"
		return
	fi

	einfo "Trying to find working CUDA host compiler"

	if ! tc-is-gcc && ! tc-is-clang; then
		die "$(tc-get-compiler-type) compiler is not supported"
	fi

	local compiler compiler_type compiler_version
	local package package_version
	local -x NVCC_CCBIN
	local NVCC_CCBIN_default

	compiler_type="$(tc-get-compiler-type)"
	compiler_version="$("${compiler_type}-major-version")"

	# try the default compiler first
	NVCC_CCBIN="$(tc-getCXX)"
	NVCC_CCBIN_default="${NVCC_CCBIN}-${compiler_version}"

	compiler="${NVCC_CCBIN/%-${compiler_version}}"

	# store the package so we can re-use it later
	package="sys-devel/${compiler_type}"
	package_version="${package}"

	ebegin "testing ${NVCC_CCBIN_default} (default)"

	while ! nvcc -v -ccbin "${NVCC_CCBIN}" - -x cu <<<"int main(){}" &>> "${T}/cuda_get_host_compiler.log" ; do
		eend 1

		while true; do
			# prepare next version
			if ! package_version="<$(best_version "${package_version}")"; then
				die "could not find a supported version of ${compiler}"
			fi

			NVCC_CCBIN="${compiler}-$(ver_cut 1 "${package_version/#<${package}-/}")"

			[[ "${NVCC_CCBIN}" != "${NVCC_CCBIN_default}" ]] && break
		done
		ebegin "testing ${NVCC_CCBIN}"
	done
	eend $?

	echo "${NVCC_CCBIN}"
	export NVCC_CCBIN
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		tc-check-openmp
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		tc-check-openmp
	fi

	if use lapack; then
		python-any-r1_pkg_setup
	fi

	if { use test && { use spqr && use cholmod && use blas && use lapack; } || use pastix; } \
		|| use blas \
		|| use lapack \
		; then
		fortran-2_pkg_setup
	fi

	if use test && use cuda && use cuda-clang; then
		llvm-r2_pkg_setup
	fi
}

src_unpack() {
	if [[ ${PV} = *9999* ]] ; then
		git-r3_src_unpack
	else
		unpack "${P}.tar.bz2"
	fi

	if use test && use lapack; then
		pushd "${S}/lapack" > /dev/null || die
		unpack "${PN}-lapack_addons-${LAPACK_ADDONS_PV}.tgz"
		popd > /dev/null || die
	fi
}

src_prepare() {
	# run patches here as we patch in test/
	cmake_src_prepare

	if use test && use lapack; then
		pushd "${S}" > /dev/null || die
		eapply "${FILESDIR}/${PN}-5.0.1-fix-lapack_testing.py.patch"
		popd > /dev/null || die
	fi
}

src_configure() {
	if use lapack; then
		# bug 878987
		# multiple definition of `cgesdd_'
		filter-lto
	fi

	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD="20"
		-DCMAKE_POSITION_INDEPENDENT_CODE="yes"

		-DEIGEN_BUILD_TESTING="$(usex test)" # Enable creation of Eigen tests.

		-DEIGEN_BUILD_BLAS="$(usex blas)" # Toggles the building of the Eigen Blas library
		-DEIGEN_BUILD_LAPACK="$(usex blas "$(usex lapack)")" # Toggles the building of the included Eigen LAPACK library

		-DEIGEN_BUILD_DOC="$(usex doc)" # Enable creation of Eigen documentation
		-DEIGEN_BUILD_PKGCONFIG="yes" # Build pkg-config .pc file for Eigen
	)

	append-cxxflags "-DEIGEN_USE_OPENBLAS_BFLOAT16=0"

	if use blas; then
		mycmakeargs+=(
			-DBUILD_SHARED_LIBS="yes"
			-DEIGEN_BUILD_SHARED_LIBS="yes"
			-DEIGEN_BUILD_STATIC_LIBS="yes"
			-DEIGEN_INSTALL_STATIC_LIBS="yes"
		)

		if use lapack; then
			mycmakeargs+=(
				-DCMAKE_POLICY_DEFAULT_CMP0148="OLD" # FindPythonInterp
				-DEIGEN_ENABLE_LAPACK_TESTS="$(usex test)"
			)
		fi
	fi

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
		mycmakeargs+=(
			-DEIGEN_LEAVE_TEST_IN_ALL_TARGET=yes # Leaves tests in the all target, needed by ctest for automatic building

			# the OpenGL testsuite is extremely brittle, bug #712808
			-DEIGEN_TEST_OPENGL="$(usex opengl)" # Enable OpenGL support in unit tests
			-DEIGEN_TEST_OPENMP="$(usex openmp)" # Enable/Disable OpenMP in tests/examples

			-DEIGEN_TEST_EXTERNAL_BLAS="$(usex !blas)" # Use external BLAS library for testsuite

			-DEIGEN_TEST_BUILD_DOCUMENTATION="no" # $(usex doc)" # Test building the doxygen documentation

			-DEIGEN_DEBUG_ASSERTS="$(usex debug)" # Enable advanced debugging of assertions
			-DEIGEN_SPLIT_LARGE_TESTS="yes" # Split large tests into smaller executables

			-DEIGEN_TEST_CUDA="$(usex cuda)" # Enable CUDA support in unit tests
			-DEIGEN_TEST_CUDA_CLANG="$(usex cuda "$(usex cuda-clang)")" # Use clang instead of nvcc to compile the CUDA tests

			-DEIGEN_TEST_HIP="$(usex hip)" # Add HIP support.

			# -DEIGEN_TEST_SYCL="$(usex sycl)" # Add Sycl support.
			# -DEIGEN_SYCL_TRISYCL="no" # Use the triSYCL Sycl implementation (ComputeCPP by default).

			$(cmake_use_find_package adolc Adolc)
			$(cmake_use_find_package boost Boost)
			$(cmake_use_find_package cholmod CHOLMOD)
			# -DDUCCFFT="$(usex ducc)"
			-DDUCC_ROOT="DUCCFFT"
			-DDUCCFFT="NOTFOUND"
			$(cmake_use_find_package fftw FFTW )
			$(cmake_use_find_package klu KLU)
			-DCMAKE_DISABLE_FIND_PACKAGE_MPREAL=yes
			# $(cmake_use_find_package opengl OpenGL) # EIGEN_TEST_OPENGL
			# $(cmake_use_find_package openmp OpenMP) # EIGEN_TEST_OPENMP
			$(cmake_use_find_package pastix PASTIX)
			# prevent pastix_nompi.h lookup it no longer exists, we enforce this via deps
			-DPASTIX_pastix_nompi.h_INCLUDE_DIRS="FOUND"

			-DPOCKETFFT="$(usex pocketfft)"
			$(cmake_use_find_package sparsehash GoogleHash)
			$(cmake_use_find_package spqr SPQR)
			$(cmake_use_find_package superlu SuperLU)
			$(cmake_use_find_package umfpack UMFPACK)
		)

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

		if use ppc || use ppc64; then
			mycmakeargs+=(
				-DEIGEN_TEST_ALTIVEC="$(usex cpu_flags_ppc_altivec)"
				-DEIGEN_TEST_VSX="$(usex cpu_flags_ppc_vsx)"
			)
		fi

		if use s390; then
			mycmakeargs+=(
				# -DEIGEN_TEST_Z13=no # Enable/Disable S390X(zEC13) ZVECTOR in tests/examples
				# -DEIGEN_TEST_Z14=no # Enable/Disable S390X(zEC14) ZVECTOR in tests/examples
			)
		fi

		if use cuda; then
			cuda_add_sandbox -w

			if use cuda-clang; then
				local llvm_prefix
				llvm_prefix="$(get_llvm_prefix -b)"

				# NVCCFLAGS gets injected into CMAKE_CXX_FLAGS, which means we need to use clang as gcc will fail with
				# error: unrecognized command-line option
				if ! tc-is-clang; then
					export CC="${CHOST}-clang-${LLVM_SLOT}"
					export CXX="${CHOST}-clang++-${LLVM_SLOT}"
				fi

				NVCCFLAGS="${NVCCFLAGS:+${NVCCFLAGS} }--libomptarget-nvptx-bc-path=${llvm_prefix}/$(get_libdir)/nvptx64-nvidia-cuda/libomptarget-nvptx.bc"

				mycmakeargs+=(
					-DCUDA_HOST_COMPILER="${CHOST}-clang++-${LLVM_SLOT}"
				)
			else
				cuda_get_host_compiler

				mycmakeargs+=(
					-DCUDA_HOST_COMPILER="${CUDAHOSTCXX}"
				)
				if [[ -v CUDACXX ]]; then
					mycmakeargs+=(
						-DCUDA_NVCC_EXECUTABLE="${CUDACXX}"
						-DCMAKE_POLICY_DEFAULT_CMP0146="OLD" # FindCUDA
					)
				fi
			fi

			if [[ "${CUDA_VERBOSE}" == true ]]; then
				mycmakeargs+=(
					-DCUDA_VERBOSE_BUILD="yes"
				)
				NVCCFLAGS+=" -v"
			fi

			if [[ -v CUDAARCHS ]]; then
				mycmakeargs+=(
					# TODO this needs to be lowest first for eigen
					-DEIGEN_CUDA_COMPUTE_ARCH="${CUDAARCHS}"
				)
			fi

			# CUDAFLAGS is used by cmake
			# NVCCFLAGS is used by cuda.eclass
			mycmakeargs+=(
				-DEIGEN_CUDA_CXX_FLAGS="${NVCCFLAGS}"

				-DCUDA_USE_STATIC_CUDA_RUNTIME="no"
			)
		fi

		if use opengl; then
			mycmakeargs+=(
				-DOpenGL_GL_PREFERENCE="GLVND"
			)
		fi
	fi

	cmake_src_configure
}

src_compile() {
	local targets=()

	if use blas; then
		targets+=( blas )
		if use lapack; then
			targets+=( lapack )
		fi
	fi

	if use test; then
		targets+=( buildtests )

		if use cuda || use hip; then
			targets+=( buildtests_gpu )
		fi

		# tests generate random data, which fails for some seeds
		# we solve this via test reruns now
		# export EIGEN_SEED=712808
	fi

	# we add doc last to capture results for buildtests
	if use doc; then
		targets+=( doc )
	fi

	if [[ -n "${targets[*]}" ]]; then
		cmake_src_compile "${targets[@]}"
	fi
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		"^ref_8$"
	)

	if use cholmod && use blas && use lapack; then
		CMAKE_SKIP_TESTS+=(
		"^cholmod_support_21$"
		"^cholmod_support_22$"
		)
	fi

	if use cuda; then
		cuda_add_sandbox -w
	fi

	if use klu && use blas; then
		CMAKE_SKIP_TESTS+=(
			"^klu_support_1$"
			"^klu_support_2$"
		)
	fi

	if use lapack; then
		CMAKE_SKIP_TESTS+=(
			"^LAPACK-xlintsts_stest_in$"
			"^LAPACK-xeigtsts_sep_in$"
			"^LAPACK-xeigtsts_svd_in$"
			"^LAPACK-xlintstd_dtest_in$"
			"^LAPACK-xeigtstd_sep_in$"
			"^LAPACK-xeigtstd_svd_in$"
			"^LAPACK-xlintstc_ctest_in$"
			"^LAPACK-xeigtstc_svd_in$"
		)
	fi

	local myctestargs=(
		-j1 # otherwise breaks due to cmake reruns
		--repeat until-pass:50
	)

	if use opengl; then
		virtx \
			cmake_src_test
	else
		cmake_src_test
	fi
}

src_install() {
	local DOCS=()
	cmake_src_install

	if use doc; then
		pushd "${BUILD_DIR}/doc" > /dev/null || die
		dodoc -r html
		popd > /dev/null || die
	fi
}
