# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="OpenCL compilation with clang compiler"
HOMEPAGE="https://github.com/RadeonOpenCompute/clang-ocl.git"
SRC_URI="https://github.com/RadeonOpenCompute/clang-ocl/archive/rocm-${PV}.tar.gz -> rocm-clang-ocl-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

RDEPEND="dev-libs/rocm-opencl-runtime:${SLOT}"
DEPEND="
	dev-util/rocm-cmake:${SLOT}
	${RDEPEND}"

S="${WORKDIR}/clang-ocl-rocm-${PV}"

src_prepare() {
	sed -e "s:HINTS \${CXX_COMPILER_PATH}/bin:NO_DEFAULT_PATH:" \
		-e "s:/opt/rocm/llvm/bin:${EPREFIX}/usr/lib/llvm/roc/bin:" \
		-e "/AMDDeviceLibs PATHS/s:/opt/rocm:${EPREFIX}/usr/lib/cmake/AMDDeviceLibs:" \
		-e "s:\${AMD_DEVICE_LIBS_PREFIX}/amdgcn/bitcode:${EPREFIX}/usr/lib/amdgcn/bitcode:" \
		-i CMakeLists.txt || die

	cmake_src_prepare
}
