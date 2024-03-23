# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake flag-o-matic llvm rocm

GTEST_COMMIT="b85864c64758dec007208e56af933fc3f52044ee"
GTEST_FILE="gtest-1.14.0_p20220421.tar.gz"

LLVM_MAX_SLOT=17

DESCRIPTION="High Performance Composable Kernel for AMD GPUs"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/composable_kernel"
SRC_URI="https://github.com/ROCmSoftwarePlatform/composable_kernel/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/google/googletest/archive/${GTEST_COMMIT}.tar.gz -> ${GTEST_FILE} )"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="debug test"
REQUIRED_USE="${ROCM_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/hip
	>=dev-db/sqlite-3.17
	sci-libs/rocBLAS:${SLOT}[${ROCM_USEDEP}]
	>=dev-libs/boost-1.72
	dev-cpp/nlohmann_json
	dev-cpp/frugally-deep
"

DEPEND="${RDEPEND}"

BDEPEND="dev-libs/half:0/1
	dev-build/rocm-cmake
"

S="${WORKDIR}/composable_kernel-rocm-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-5.7.1-enable-test-examples.patch"
)

src_prepare() {
	sed -e '/-Werror/d' -i cmake/EnableCompilerWarnings.cmake || die
	cmake_src_prepare
}

src_configure() {
	if ! use debug; then
		append-cflags "-DNDEBUG"
		append-cxxflags "-DNDEBUG"
		CMAKE_BUILD_TYPE="Release"
	else
		CMAKE_BUILD_TYPE="Debug"
	fi

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_DEV=OFF
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DBUILD_TESTS=$(usex test ON OFF)
	)

	if use test; then
		mycmakeargs+=(
			-DGOOGLETEST_DIR="${WORKDIR}/googletest-${GTEST_COMMIT}"
		)
	fi

	CXX=hipcc cmake_src_configure
}

src_test() {
	check_amdgpu
	LD_LIBRARY_PATH="${BUILD_DIR}"/lib cmake_src_test -j1
}
