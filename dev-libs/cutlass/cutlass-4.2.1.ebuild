# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit cuda cmake python-any-r1 flag-o-matic toolchain-funcs

DESCRIPTION="CUDA Templates for Linear Algebra Subroutines"
HOMEPAGE="https://github.com/NVIDIA/cutlass"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NVIDIA/${PN}"
else
	SRC_URI="
		https://github.com/NVIDIA/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

X86_CPU_FEATURES=(
	f16c:f16c
)
CPU_FEATURES=( "${X86_CPU_FEATURES[@]/#/cpu_flags_x86_}" )

IUSE="clang-cuda cublas cudnn doc dot examples +headers-only jumbo-build performance profiler test tools ${CPU_FEATURES[*]%:*}"

REQUIRED_USE="
	headers-only? (
		!examples
		!profiler
		!test
	)
	test? (
		tools
	)
"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/nvidia-cuda-toolkit:=
"
DEPEND="${RDEPEND}
	test? (
		${PYTHON_DEPS}
		dev-cpp/gtest
		cudnn? (
			dev-libs/cudnn:=
		)
	)
	tools? (
		${PYTHON_DEPS}
	)
"

pkg_setup() {
	if use test || use tools; then
		python-any-r1_pkg_setup
	fi
}

src_configure() {
	# we can use clang as default
	if use clang-cuda && ! tc-is-clang; then
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"
	else
		tc-export CXX CC
	fi

	cuda_add_sandbox
	addpredict "/dev/char/"

	local mycmakeargs=(
		-DCMAKE_POLICY_DEFAULT_CMP0156="OLD" # cutlass_add_library

		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen="$(usex !doc)"

		-DCUTLASS_REVISION="${PVR}"
		-DCUTLASS_ENABLE_CUBLAS="$(usex cublas)"
		-DCUTLASS_ENABLE_CUDNN="$(usex cudnn)"
		-DCUTLASS_ENABLE_EXAMPLES="$(usex examples)"
		-DCUTLASS_ENABLE_F16C="$(usex cpu_flags_x86_f16c)"
		-DCUTLASS_ENABLE_GTEST_UNIT_TESTS="$(usex test)"
		-DCUTLASS_ENABLE_HEADERS_ONLY="$(usex headers-only)"
		-DCUTLASS_ENABLE_LIBRARY="$(usex !headers-only)"
		-DCUTLASS_ENABLE_PERFORMANCE="$(usex performance)"
		-DCUTLASS_ENABLE_PROFILER="$(usex profiler)"
		-DCUTLASS_ENABLE_PROFILER_UNIT_TESTS="$(usex test "$(usex profiler)")"
		-DCUTLASS_ENABLE_TESTS="$(usex test)"
		-DCUTLASS_ENABLE_TOOLS="$(usex tools)"
		-DCUTLASS_INSTALL_TESTS="no"
		-DCUTLASS_NVCC_ARCHS="${CUDAARCHS:-all-major}"
		-DCUTLASS_UNITY_BUILD_ENABLED="$(usex jumbo-build)"
		-DCUTLASS_USE_SYSTEM_GOOGLETEST="yes"
		-DIMPLICIT_CMAKE_CXX_STANDARD="yes"
	)

	# clang-cuda needs to filter mfpmath
	if use clang-cuda; then
		filter-mfpmath sse
		filter-mfpmath i386

		mycmakeargs+=(
			-DCMAKE_CUDA_HOST_COMPILER="${CHOST}-clang++"
		)
	else
		mycmakeargs+=(
			-DCMAKE_CUDA_HOST_COMPILER="$(cuda_gccdir)"
		)
	fi

	if use cudnn; then
		mycmakeargs+=(
			-DCUDNN_INCLUDE_DIR="${CUDNN_PATH:-${ESYSROOT}/opt/cuda}/linux/include"
			-DCUDNN_LIBRARY="${CUDNN_PATH:-${ESYSROOT}/opt/cuda}/$(get_libdir)/libcudnn.so"
		)
	fi

	if use doc; then
		mycmakeargs+=(
			-DCUTLASS_ENABLE_DOXYGEN_DOT="$(usex dot)"
		)
	fi

	if use test; then
		mycmakeargs+=(
			-DCUTLASS_TEST_LEVEL="0"
		)

		append-cxxflags -DNDEBUG
	fi

	cmake_src_configure
}

src_test() {
	cuda_add_sandbox -w

	local myctestargs=(
	)

	local CMAKE_SKIP_TESTS=(
		"ctest_examples_41_fmha_backward_python$"
	)

	cmake_src_test -j1
	cmake_build test_unit "${myctestargs[@]}" -j1
}

src_install() {
	cmake_src_install

	rm -r "${ED}/usr/test" || die
}
