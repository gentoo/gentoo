# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake flag-o-matic llvm rocm

LLVM_MAX_SLOT=14

DESCRIPTION="AMD's Machine Intelligence Library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen"
SRC_URI="https://github.com/ROCmSoftwarePlatform/MIOpen/archive/rocm-${PV}.tar.gz -> MIOpen-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-util/hip-5.1.3
	>=dev-db/sqlite-3.17
	sci-libs/rocBLAS:${SLOT}[${ROCM_USEDEP}]
	>=dev-libs/boost-1.72
"

DEPEND="${RDEPEND}"

BDEPEND="dev-libs/half:0/1
	dev-util/rocm-cmake
"

S="${WORKDIR}/MIOpen-rocm-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-4.2.0-disable-no-inline-boost.patch"
	"${FILESDIR}/${PN}-4.2.0-gcc11-numeric_limits.patch"
	"${FILESDIR}/${PN}-5.0.2-strip-xnack-in-flags.patch"
	"${FILESDIR}/${PN}-4.3.0-fix-interface-include-in-HIP_COMPILER_FLAGS.patch"
	"${FILESDIR}/${PN}-4.3.0-enable-test.patch"
	"${FILESDIR}/${PN}-5.1.3-gfx1031.patch"
	"${FILESDIR}/${PN}-5.1.3-deprecate-clang-ocl.patch"
	"${FILESDIR}/${PN}-5.1.3-no-strip.patch"
	"${FILESDIR}/${PN}-5.1.3-include-array.patch"
	"${FILESDIR}/${PN}-5.1.3-avoid-metadata-error-for-vanilla-clang.patch"
)

src_prepare() {
	cmake_src_prepare

	sed -e "s:/opt/rocm/llvm:$(get_llvm_prefix ${LLVM_MAX_SLOT}) NO_DEFAULT_PATH:" \
		-e "s:/opt/rocm/hip:$(hipconfig -p) NO_DEFAULT_PATH:" \
		-e '/set( MIOPEN_INSTALL_DIR/s:miopen:${CMAKE_INSTALL_PREFIX}:' \
		-e '/MIOPEN_TIDY_ERRORS ALL/d' \
		-i CMakeLists.txt || die

	sed -e "/rocm_install_symlink_subdir(\${MIOPEN_INSTALL_DIR})/d" -i src/CMakeLists.txt || die
	sed -e "/add_test/s:--build \${CMAKE_CURRENT_BINARY_DIR}:--build ${BUILD_DIR}:" -i test/CMakeLists.txt || die

	sed -e "s:\${AMD_DEVICE_LIBS_PREFIX}/lib:${EPREFIX}/usr/lib/amdgcn/bitcode:" -i cmake/hip-config.cmake || die

	# This plus avoid-metadata-error-for-vanilla-clang.patch fix bug mentioned
	# in https://github.com/ROCmSoftwarePlatform/MIOpen/issues/1731
	find src/kernels -name "*.s" -exec \
		sed -e "s/.name: n /.name: x /g" -e "s/.name: y /.name: z /g" \
			-e "s/.name: y,/.name: z,/g" -i {} \; || die
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
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DMIOPEN_BACKEND=HIP
		-DBoost_USE_STATIC_LIBS=OFF
		-DMIOPEN_USE_MLIR=OFF
		-DBUILD_TESTS=$(usex test ON OFF)
		-DMIOPEN_TEST_ALL=$(usex test ON OFF)
	)

	if use test; then
		for gpu_target in ${AMDGPU_TARGETS}; do
			mycmakeargs+=( -DMIOPEN_TEST_${gpu_target^^}=ON )
		done
	fi

	addpredict /dev/kfd
	addpredict /dev/dri/
	append-cxxflags "--rocm-path=$(hipconfig -R)"
	append-cxxflags "--hip-device-lib-path=${EPREFIX}/usr/lib/amdgcn/bitcode"
	CXX="$(get_llvm_prefix ${LLVM_MAX_SLOT})/bin/clang++" cmake_src_configure
}

src_test() {
	check_amdgpu
	export LD_LIBRARY_PATH="${BUILD_DIR}"/lib
	MAKEOPTS="-j1" cmake_src_test
}
