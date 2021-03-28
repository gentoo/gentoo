# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Radeon Open Compute Common Language Runtime"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/ROCclr"
SRC_URI="https://github.com/ROCm-Developer-Tools/ROCclr/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/rocm-${PV}.tar.gz -> rocm-opencl-runtime-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

RDEPEND=">=dev-libs/rocm-comgr-${PV}
	>=dev-libs/rocr-runtime-${PV}"
DEPEND="${RDEPEND}
	>=dev-libs/rocm-comgr-${PV}
	virtual/opengl
	>=dev-util/rocm-cmake-${PV}"

PATCHES=(
	"${FILESDIR}/rocclr-3.7.0-cmake-install-destination.patch"
)

S="${WORKDIR}/ROCclr-rocm-${PV}"

src_configure() {
	local mycmakeargs=(
		-DUSE_COMGR_LIBRARY=YES
		-DOPENCL_DIR="${WORKDIR}/ROCm-OpenCL-Runtime-rocm-${PV}"
		-DCMAKE_INSTALL_PREFIX="/usr"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# This should be fixed in the CMakeLists.txt
	sed -e "s:${BUILD_DIR}:${EPREFIX}/usr:" -i "${D}/usr/lib/cmake/rocclr/ROCclrConfig.cmake" || die
}
