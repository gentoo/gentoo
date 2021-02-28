# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="ROCm SPARSE marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipSPARSE"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipSPARSE/archive/rocm-${PV}.tar.gz -> hipSPARSE-$(ver_cut 1-2).tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND=">=dev-util/rocminfo-$(ver_cut 1-2)
		 =dev-util/hip-$(ver_cut 1-2)*
		 =sci-libs/rocSPARSE-${PV}*"
DEPEND="${RDEPEND}"

S="${WORKDIR}/hipSPARSE-rocm-${PV}"

src_prepare() {
	sed -e "s/PREFIX hipsparse//" \
		-e "/<INSTALL_INTERFACE/s,include,include/hipsparse," \
		-e "s:rocm_install_symlink_subdir(hipsparse):#rocm_install_symlink_subdir(hipsparse):" \
		-i library/CMakeLists.txt || die

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
		-DHIP_RUNTIME="ROCclr"
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DCMAKE_INSTALL_INCLUDEDIR=include/hipsparse
	)

	cmake_src_configure
}
