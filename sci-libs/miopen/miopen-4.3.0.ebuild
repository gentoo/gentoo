# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="AMD's Machine Intelligence Library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen"
SRC_URI="https://github.com/ROCmSoftwarePlatform/MIOpen/archive/rocm-${PV}.tar.gz -> MIOpen-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/hip:${SLOT}
	>=dev-db/sqlite-3.17
	dev-libs/ocl-icd
	dev-util/rocm-clang-ocl:${SLOT}
	sci-libs/rocBLAS:${SLOT}
	>=dev-libs/boost-1.72
"

DEPEND="${RDEPEND}"

BDEPEND="dev-libs/half:0/1"

S="${WORKDIR}/MIOpen-rocm-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-4.2.0-disable-no-inline-boost.patch"
	"${FILESDIR}/${PN}-4.2.0-gcc11-numeric_limits.patch"
	"${FILESDIR}/${PN}-4.3.0-strip-xnack-in-flags.patch"
	"${FILESDIR}/${PN}-4.3.0-fix-interface-include-in-HIP_COMPILER_FLAGS.patch"
	"${FILESDIR}/${PN}-4.3.0-enable-test.patch"
	"${FILESDIR}/${PN}-4.3.0-no-strip.patch"
)

src_prepare() {
	sed -e "s:/opt/rocm/llvm:""${EPREFIX}""/usr/lib/llvm/roc/ NO_DEFAULT_PATH:" \
		-e "s:/opt/rocm/hip:""${EPREFIX}""/usr/lib/hip/ NO_DEFAULT_PATH:" \
		-e '/set( MIOPEN_INSTALL_DIR/s:miopen:${CMAKE_INSTALL_PREFIX}:' \
		-e '/set(MIOPEN_SYSTEM_DB_PATH/s:${CMAKE_INSTALL_PREFIX}/::' \
		-e '/MIOPEN_TIDY_ERRORS ALL/d' \
		-i CMakeLists.txt || die

	sed -e "/rocm_install_symlink_subdir(\${MIOPEN_INSTALL_DIR})/d" -i src/CMakeLists.txt || die
	sed -e "/add_test/s:--build \${CMAKE_CURRENT_BINARY_DIR}:--build ${BUILD_DIR}:" -i test/CMakeLists.txt || die

	sed -e "s:\${AMD_DEVICE_LIBS_PREFIX}/lib:${EPREFIX}/usr/lib/amdgcn/bitcode:" -i cmake/hip-config.cmake || die

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

	export CXX="${EPREFIX}/usr/lib/llvm/roc/bin/clang++"

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DMIOPEN_BACKEND=HIP
		-DBoost_USE_STATIC_LIBS=OFF
		-DBUILD_TESTS=$(usex test ON OFF)
		${AMDGPU_TARGETS+-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"}
	)

	cmake_src_configure
}
