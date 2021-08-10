# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Thrust dependent software on AMD GPUs"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocThrust"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocThrust/archive/rocm-${PV}.tar.gz -> rocThrust-${PV}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND=">=dev-util/hip-${PV}
	=sci-libs/rocPRIM-${PV}*"
DEPEND="${RDEPEND}"

S="${WORKDIR}/rocThrust-rocm-${PV}"

PATCHES="${FILESDIR}/rocThrust-4.0-operator_new.patch"

src_prepare() {
	sed -e "/PREFIX rocthrust/d" \
		-e "/DESTINATION/s:rocthrust/include/thrust:include/rocthrust/thrust:" \
		-e "/rocm_install_symlink_subdir(rocthrust)/d" \
		-e "/<INSTALL_INTERFACE/s:rocthrust/include/:include/rocthrust/:" -i thrust/CMakeLists.txt || die
	sed -e "s:\${CMAKE_INSTALL_INCLUDEDIR}:&/rocthrust:" \
		-e "s:\${ROCM_INSTALL_LIBDIR}:\${CMAKE_INSTALL_LIBDIR}:" -i cmake/ROCMExportTargetsHeaderOnly.cmake || die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	# Grant access to the device
	addwrite /dev/kfd
	addpredict /dev/dri/

	# Compiler to use
	export CXX=hipcc

	local mycmakeargs=(
		-DBUILD_TEST=OFF
	)

	cmake_src_configure
}
