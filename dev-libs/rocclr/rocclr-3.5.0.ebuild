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
	virtual/opengl
	>=dev-util/rocm-cmake-${PV}"

PATCHES=(
	"${FILESDIR}/rocclr-3.5.0-cmake-install-destination.patch"
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
	sed -e "s:/var/tmp/portage/dev-libs/${PF}/work/rocclr-${PV}_build:/usr/lib64:" -i "${BUILD_DIR}/amdrocclr_staticTargets.cmake"
	insinto /usr/lib64/cmake/rocclr
	doins "${BUILD_DIR}/amdrocclr_staticTargets.cmake"

	cmake_src_install
}
