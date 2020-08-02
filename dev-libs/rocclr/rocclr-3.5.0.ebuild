# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Radeon Open Compute Common Language Runtime"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/ROCclr"
SRC_URI="https://github.com/ROCm-Developer-Tools/ROCclr/archive/roc-${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/roc-${PV}.tar.gz -> rocm-opencl-runtime-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

RDEPEND=">=dev-libs/rocm-comgr-${PV}"
DEPEND="${RDEPEND}
	>=dev-libs/rocm-comgr-${PV}
	virtual/opengl
	>=dev-util/rocm-cmake-${PV}"

PATCHES=(
	"${FILESDIR}/rocclr-3.5.0-cmake-install-destination.patch"
	"${FILESDIR}/rocclr-3.5.0-find-opencl.patch"
)

S="${WORKDIR}/ROCclr-roc-${PV}"

src_configure() {
	local mycmakeargs=(
		-DUSE_COMGR_LIBRARY=YES
		-DOPENCL_DIR="${WORKDIR}/ROCm-OpenCL-Runtime-roc-${PV}"
		-DCMAKE_INSTALL_PREFIX="/usr"
	)
	cmake_src_configure
}

src_install() {
	# This should be fixed in the CMakeLists.txt to get this installed automatically
	sed -e "s:${BUILD_DIR}:/usr/$(get_libdir):" -i "${BUILD_DIR}/amdrocclr_staticTargets.cmake"
	insinto /usr/$(get_libdir)/cmake/rocclr
	doins "${BUILD_DIR}/amdrocclr_staticTargets.cmake"

	cmake_src_install
}
