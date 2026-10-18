# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}
LLVM_COMPAT=( 23 )
PYTHON_COMPAT=( python3_{11..15} )

inherit cmake flag-o-matic llvm-r2 python-any-r1 rocm

DESCRIPTION="AMD's Machine Intelligence Library"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/miopen"
SRC_URI="https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/miopen.tar.gz -> miopen-${PV}.tar.gz"
S="${WORKDIR}/miopen"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

IUSE="composable-kernel debug +hipblaslt +rocblas roctracer test"

REQUIRED_USE="
	${ROCM_REQUIRED_USE}
	composable-kernel? (
		|| (
			amdgpu_targets_gfx908 amdgpu_targets_gfx90a amdgpu_targets_gfx942 amdgpu_targets_gfx950
			amdgpu_targets_gfx1100 amdgpu_targets_gfx1101 amdgpu_targets_gfx1102
			amdgpu_targets_gfx1150 amdgpu_targets_gfx1151 amdgpu_targets_gfx1152 amdgpu_targets_gfx1153
			amdgpu_targets_gfx1200 amdgpu_targets_gfx1201
		)
	)
"

# tests can freeze machine depending on gpu/kernel
RESTRICT="test"

RDEPEND="
	dev-util/hip:${SLOT}
	dev-db/sqlite:3
	app-arch/bzip2
	sci-libs/rocRAND:${SLOT}
	dev-libs/rocm-comgr:${SLOT}

	composable-kernel? ( sci-libs/composable-kernel:${SLOT} )
	hipblaslt? ( sci-libs/hipBLASLt:${SLOT} )
	rocblas? ( sci-libs/rocBLAS:${SLOT} )
	roctracer? ( dev-util/roctracer:${SLOT} )
"

DEPEND="
	${RDEPEND}
	dev-cpp/eigen:3
	=dev-cpp/frugally-deep-0.15*
	dev-cpp/nlohmann_json
	>=dev-libs/half-1.12.0-r1
	hipblaslt? ( sci-libs/hipBLAS-common:${SLOT} )
	test? ( dev-cpp/gtest )
"

BDEPEND="
	${PYTHON_DEPS}
	dev-build/rocm-cmake
"

PATCHES=(
	"${FILESDIR}"/${P}-llvm-23.patch
	"${FILESDIR}"/${P}-llvm-23-asm-fake16.patch
)

src_prepare() {
	cmake_src_prepare

	# typedef conflict in kernels compiled at runtime
	# https://github.com/ROCm/rocm-libraries/commit/d91c43b5755
	sed -e 's/__hip_internal::uint64_t uint64_t/__UINT64_TYPE__ uint64_t/' \
		-e 's/__hip_internal::int64_t int64_t/__INT64_TYPE__ int64_t/' \
		-i src/kernels/miopen_cstdint.hpp || die

	# test categories need shared/ctest from the rocm-libraries monorepo
	sed -e '/shared\/ctest\/TestCategories.cmake/d' \
		-e 's|^if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/test_categories.yaml")|if(FALSE)|' \
		-i test/gtest/CMakeLists.txt || die

	# -Werror -Wthread-safety: libc++ annotates its mutexes, and lock_file.hpp fails the analysis.
	# The option comes after CXXFLAGS, so -Wno-thread-safety-analysis there has no effect.
	sed -e "/^    -Wthread-safety$/d" -i cmake/EnableCompilerWarnings.cmake || die

	# libc++ does not include <atomic> transitively
	sed -e "/#include <algorithm>/a #include <atomic>" -i driver/mloPoolingHost.hpp || die
	sed -e "/#include <cmath>/a #include <atomic>" -i driver/mloConvHost.hpp || die
}

src_configure() {
	rocm_use_clang

	if ! use debug; then
		append-cflags "-DNDEBUG"
		append-cxxflags "-DNDEBUG"
		CMAKE_BUILD_TYPE="Release"
	else
		CMAKE_BUILD_TYPE="Debug"
	fi

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DGPU_TARGETS="$(get_amdgpu_flags)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DMIOPEN_BACKEND=HIP
		-DMIOPEN_STRIP_SYMBOLS=OFF
		# hipconv kernels (gfx950/gfx1250 only) need LLVM 24 builtins
		-DMIOPEN_USE_HIPCONV=OFF
		-DMIOPEN_INSTALL_GPU_DATABASES="$(get_amdgpu_flags)"
		-DMIOPEN_USE_MLIR=OFF
		-DMIOPEN_USE_ROCTRACER=$(usex roctracer ON OFF)
		-DMIOPEN_USE_ROCBLAS=$(usex rocblas ON OFF)
		-DMIOPEN_USE_HIPBLASLT=$(usex hipblaslt ON OFF)
		-DMIOPEN_USE_COMPOSABLEKERNEL=$(usex composable-kernel ON OFF)
		-DBUILD_TESTING=$(usex test ON OFF)
		-DROCM_SYMLINK_LIBS=OFF
		-DMIOPEN_HIP_COMPILER="${ESYSROOT}/usr/bin/hipcc"
		-DMIOPEN_AMDGCN_ASSEMBLER="$(get_llvm_prefix)/bin/clang"
		-DMIOPEN_OFFLOADBUNDLER_BIN="$(get_llvm_prefix)/bin/clang-offload-bundler"
		-DPython3_EXECUTABLE="${PYTHON}"
		-DCMAKE_DISABLE_FIND_PACKAGE_zstd=ON
	)

	if use test; then
		mycmakeargs+=(
			-DMIOPEN_TEST_ALL=OFF
			-DMIOPEN_TEST_GDB=OFF
			-DMIOPEN_TEST_DISCRETE=OFF
			-DGTEST_PARALLEL_LEVEL=4
		)
		# needed by rocminfo
		addpredict /dev/random
		check_amdgpu
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use test && cmake_build miopen-tests
}

src_test() {
	check_amdgpu
	LD_LIBRARY_PATH="${BUILD_DIR}/$(get_libdir)" cmake_src_test -j1
}

src_install() {
	cmake_src_install

	if use test; then
		rm -r "${ED}"/usr/bin/{miopen_gtest,MIOpen} "${ED}"/usr/share/miopen/bin || die
	fi
}
