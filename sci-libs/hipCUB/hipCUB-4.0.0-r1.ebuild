# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A thin wrapper library on top of rocPRIM or CUB"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipCUB"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipCUB/archive/rocm-${PV}.tar.gz -> hipCUB-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*
	=sci-libs/rocPRIM-${PV}*"
DEPEND="${RDEPEND}"

S="${WORKDIR}/hipCUB-rocm-${PV}"

src_prepare() {
	sed -e "/PREFIX hipcub/d" \
		-e "/DESTINATION/s:hipcub/include/:include/:" \
		-e "/rocm_install_symlink_subdir(hipcub)/d" \
		-e "/<INSTALL_INTERFACE/s:hipcub/include/:include/hipcub/:" -i hipcub/CMakeLists.txt || die

	sed	-e "s:\${ROCM_INSTALL_LIBDIR}:\${CMAKE_INSTALL_LIBDIR}:" -i cmake/ROCMExportTargetsHeaderOnly.cmake || die

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
