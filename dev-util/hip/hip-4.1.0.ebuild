# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake flag-o-matic prefix

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP"
SRC_URI="https://github.com/ROCm-Developer-Tools/HIP/archive/rocm-${PV}.tar.gz -> rocm-hip-${PV}.tar.gz"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

IUSE="debug profile"

# Don't strip to prevent some tests from failing.
RESTRICT="strip"

DEPEND=">=dev-libs/rocclr-$(ver_cut 1-2)
	>=dev-util/rocminfo-$(ver_cut 1-2)
	=sys-devel/llvm-roc-${PV}*[runtime]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.1.0-DisableTest.patch"
	"${FILESDIR}/${PN}-3.9.0-add-include-directories.patch"
	"${FILESDIR}/${PN}-3.5.1-config-cmake-in.patch"
	"${FILESDIR}/${PN}-3.5.1-hip_vector_types.patch"
	"${FILESDIR}/${PN}-3.9.0-lpl_ca-add-include.patch"
)

S="${WORKDIR}/HIP-rocm-${PV}"

src_prepare() {
	cmake_src_prepare
	eapply_user

	# Use Gentoo version number, otherwise git hash is attempted in vain.
	sed -e "/set (HIP_LIB_VERSION_STRING/cset (HIP_LIB_VERSION_STRING ${PVR})" -i CMakeLists.txt || die

	# disable PCH, because it results in a build error in ROCm 4.0.0
	sed -e "s:option(__HIP_ENABLE_PCH:#option(__HIP_ENABLE_PCH:" -i "${S}/CMakeLists.txt" || die

	# "hcc" is deprecated and not installed, new platform is "rocclr";
	# Setting HSA_PATH to "/usr" results in setting "-isystem /usr/include"
	# which makes "stdlib.h" not found when using "#include_next" in header files;
	sed -e "/HIP_PLATFORM.*HIP_COMPILER.*clang/s:hcc:rocclr:" \
		-e "/FLAGS .= \" -isystem \$HSA_PATH/d" \
		-e "s:\$ENV{'DEVICE_LIB_PATH'}:'/usr/lib/amdgcn/bitcode':" \
		-i bin/hipcc || die

	# replace hcc remnants with modern rocclr.
	sed -e "/HIP_PLATFORM.*STREQUAL/s:hcc:rocclr:" -i cmake/FindHIP/run_hipcc.cmake || die

	# correctly find HIP_CLANG_INCLUDE_PATH using cmake
	sed -e "/set(HIP_CLANG_ROOT/s:\"\${ROCM_PATH}/llvm\":/usr/lib/llvm/roc:" -i hip-config.cmake.in || die

	# change --hip-device-lib-path to "/usr/lib/amdgcn/bitcode", must align with "dev-libs/rocm-device-libs"
	sed -e "s:\${AMD_DEVICE_LIBS_PREFIX}/lib:/usr/lib/amdgcn/bitcode:" \
		-i "${S}/hip-config.cmake.in" || die

	einfo "prefixing hipcc and its utils..."
	hprefixify $(grep -rl --exclude-dir=build/ "/usr" "${S}")
}

src_configure() {
	strip-flags
	if ! use debug; then
		append-cflags "-DNDEBUG"
		append-cxxflags "-DNDEBUG"
		buildtype="Release"
	else
		buildtype="Debug"
	fi

	# TODO: Currently a GENTOO configuration is build,
	# this is also used in the cmake configuration files
	# which will be installed to find HIP;
	# Other ROCm packages expect a "RELEASE" configuration,
	# see "hipBLAS"
	local mycmakeargs=(
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/lib/llvm/roc"
		-DCMAKE_BUILD_TYPE=${buildtype}
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hip"
		-DBUILD_HIPIFY_CLANG=OFF
		-DHIP_PLATFORM=rocclr
		-DHIP_COMPILER=clang
		-DROCM_PATH="${EPREFIX}/usr"
		-DHSA_PATH="${EPREFIX}/usr"
		-DUSE_PROF_API=$(usex profile 1 0)
		-DROCclr_DIR="${EPREFIX}"/usr/include/rocclr
	)

	cmake_src_configure
}

src_install() {
	echo "HSA_PATH=${EPREFIX}/usr" > 99hip || die
	echo "ROCM_PATH=${EPREFIX}/usr" >> 99hip || die
	echo "HIP_PLATFORM=amd" >> 99hip || die
	echo "HIP_RUNTIME=rocclr" >> 99hip || die
	echo "HIP_COMPILER=clang" >> 99hip || die
	echo "HIP_CLANG_PATH=${EPREFIX}/usr/lib/llvm/roc/bin" >> 99hip || die

	echo "PATH=${EPREFIX}/usr/lib/hip/bin" >> 99hip || die
	echo "HIP_PATH=${EPREFIX}/usr/lib/hip" >> 99hip || die
	echo "LDPATH=${EPREFIX}/usr/lib/hip/lib" >> 99hip || die
	echo "ROOTPATH=${EPREFIX}/usr/lib/hip/bin" >> 99hip || die

	doenvd 99hip

	cmake_src_install
}
