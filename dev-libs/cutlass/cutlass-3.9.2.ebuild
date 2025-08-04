# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit cuda cmake python-any-r1 flag-o-matic toolchain-funcs

DESCRIPTION="CUDA Templates for Linear Algebra Subroutines"
HOMEPAGE="https://github.com/NVIDIA/cutlass"
SRC_URI="https://github.com/NVIDIA/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

X86_CPU_FEATURES=(
	f16c:f16c
)
CPU_FEATURES=( "${X86_CPU_FEATURES[@]/#/cpu_flags_x86_}" )

IUSE="clang-cuda cublas cudnn doc dot examples +headers-only jumbo-build performance profiler test tools ${CPU_FEATURES[*]%:*}"

REQUIRED_USE="
	headers-only? (
		!examples !test
	)
	test? ( tools )
"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/nvidia-cuda-toolkit:=
"
DEPEND="${RDEPEND}
	test? (
		${PYTHON_DEPS}
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

src_prepare() {
	cmake_src_prepare

	sed \
		-e '/-std=/s/17/20/g' \
		-i \
			CMakeLists.txt \
			python/cutlass/backend/compiler.py \
			python/cutlass/emit/pytorch.py \
			python/docs/_modules/cutlass/emit/pytorch.html \
			test/unit/nvrtc/thread/nvrtc_contraction.cu \
			test/unit/nvrtc/thread/testbed.h \
			media/docs/cpp/ide_setup.md \
		|| die

}

src_configure() {
	# we can use clang as default
	if use clang-cuda && ! tc-is-clang ; then
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"
	else
		tc-export CXX CC
	fi

	# clang-cuda needs to filter mfpmath
	if use clang-cuda ; then
		filter-mfpmath sse
		filter-mfpmath i386
	fi
	if use clang-cuda ; then
		export CUDACXX=clang++
	fi

	cuda_add_sandbox
	addpredict "/dev/char/"

	local mycmakeargs=(
		-DCMAKE_POLICY_DEFAULT_CMP0156="OLD" # cutlass_add_library

		# -DCMAKE_CUDA_COMPILER="$(cuda_get_host_compiler)" # nvcc/clang++
		-DCMAKE_CUDA_FLAGS="$(cuda_gccdir -f)"

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
		-DCUTLASS_NVCC_ARCHS="${CUDAARCHS}"
		-DCUTLASS_UNITY_BUILD_ENABLED="$(usex jumbo-build)"
		-DCUTLASS_USE_SYSTEM_GOOGLETEST="yes"
		-DIMPLICIT_CMAKE_CXX_STANDARD="yes"
	)

	if use doc; then
		mycmakeargs+=(
			# Use dot to generate graphs in the doxygen documentation.
			-DCUTLASS_ENABLE_DOXYGEN_DOT="$(usex dot)"
		)
	fi

	if use test; then
		mycmakeargs+=(
			-DCUTLASS_TEST_LEVEL="2"
		)
		append-cxxflags -DNDEBUG
	fi

	cmake_src_configure
}

src_test() {
	cuda_add_sandbox -w
	cmake_src_test
}

src_install() {
	cmake_src_install
	rm -r "${ED}"/usr/test || die
}
