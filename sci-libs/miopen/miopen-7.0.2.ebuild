# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}
LLVM_COMPAT=( 20 )

inherit cmake flag-o-matic llvm-r1 rocm

DESCRIPTION="AMD's Machine Intelligence Library"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/miopen"
SRC_URI="https://github.com/ROCm/MIOpen/archive/rocm-${PV}.tar.gz -> MIOpen-${PV}.tar.gz"
S="${WORKDIR}/MIOpen-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

IUSE="composable-kernel debug hipblaslt rocblas roctracer test"

REQUIRED_USE="
	${ROCM_REQUIRED_USE}
	composable-kernel? (
		|| ( amdgpu_targets_gfx908 amdgpu_targets_gfx90a amdgpu_targets_gfx942 amdgpu_targets_gfx950 )
	)
"

# tests can freeze machine depending on gpu/kernel
RESTRICT="test"

RDEPEND="
	dev-util/hip:${SLOT}
	dev-db/sqlite:3
	app-arch/bzip2
	sci-libs/rocRAND:${SLOT}
	dev-libs/boost:=
	dev-libs/rocm-comgr:${SLOT}

	composable-kernel? ( sci-libs/composable-kernel:${SLOT} )
	hipblaslt? ( sci-libs/hipBLASLt:${SLOT} )
	rocblas? ( sci-libs/rocBLAS:${SLOT} )
	roctracer? ( dev-util/roctracer:${SLOT} )
"

DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
	>=dev-libs/half-1.12.0-r1
	test? ( dev-cpp/gtest )

	amdgpu_targets_gfx908? ( =dev-cpp/frugally-deep-0.15* )
	amdgpu_targets_gfx940? ( =dev-cpp/frugally-deep-0.15* )
	amdgpu_targets_gfx941? ( =dev-cpp/frugally-deep-0.15* )
	amdgpu_targets_gfx942? ( =dev-cpp/frugally-deep-0.15* )
"

BDEPEND="
	dev-build/rocm-cmake
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.1.1-build-all-tests.patch
)

src_prepare() {
	cmake_src_prepare

	sed -e '/MIOPEN_TIDY_ERRORS ALL/d' \
		-e 's/FLAGS_RELEASE} -s/FLAGS_RELEASE}/g' \
		-i CMakeLists.txt || die

	sed -e "/add_test/s:--build \${CMAKE_CURRENT_BINARY_DIR}:--build ${BUILD_DIR}:" \
		-i test/CMakeLists.txt || die
}

src_configure() {
	rocm_use_hipcc

	if ! use debug; then
		append-cflags "-DNDEBUG"
		append-cxxflags "-DNDEBUG"
		CMAKE_BUILD_TYPE="Release"
	else
		CMAKE_BUILD_TYPE="Debug"
	fi

	local use_ai_tuning=OFF
	if use amdgpu_targets_gfx908 || use amdgpu_targets_gfx940 || use amdgpu_targets_gfx941 \
	|| use amdgpu_targets_gfx942; then
		use_ai_tuning=ON
	fi

	# Too many warnings
	append-cxxflags -Wno-thread-safety-analysis

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DGPU_TARGETS="$(get_amdgpu_flags)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DMIOPEN_BACKEND=HIP
		-DBoost_USE_STATIC_LIBS=OFF
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
		-DHIP_OC_COMPILER="$(get_llvm_prefix)/bin/clang"
		-DMIOPEN_ENABLE_AI_KERNEL_TUNING=${use_ai_tuning}
		-DMIOPEN_ENABLE_AI_IMMED_MODE_FALLBACK=${use_ai_tuning}
	)

	if use test; then
		mycmakeargs+=(
			-DMIOPEN_TEST_ALL=ON
			-DMIOPEN_TEST_GDB=OFF
		)
		# needed by rocminfo
		addpredict /dev/random
		check_amdgpu
	fi

	cmake_src_configure
}

src_test() {
	check_amdgpu
	LD_LIBRARY_PATH="${BUILD_DIR}"/lib MIOPEN_SYSTEM_DB_PATH="${BUILD_DIR}"/share/miopen/db/ cmake_src_test -j1
}

src_install() {
	cmake_src_install
}
