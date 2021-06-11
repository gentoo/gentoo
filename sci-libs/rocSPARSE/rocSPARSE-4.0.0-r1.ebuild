# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Basic Linear Algebra Subroutines for sparse computation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocSPARSE"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocSPARSE/archive/rocm-${PV}.tar.gz -> rocSPARSE-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*
	 =sci-libs/rocPRIM-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}"

S="${WORKDIR}/rocSPARSE-rocm-${PV}"

rocSPARSE_V="0.1"

BUILD_DIR="${S}/build/release"

src_prepare() {
	sed -e "s/PREFIX rocsparse//" \
		-e "/<INSTALL_INTERFACE/s,include,include/rocsparse," \
		-e "/rocm_install_symlink_subdir(rocsparse)/d" \
		-e "s:rocsparse/include:include/rocsparse:" \
		-i "${S}/library/CMakeLists.txt" || die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	# Grant access to the device to omit a sandbox violation
	addwrite /dev/kfd
	addpredict /dev/dri/

	# Compiler to use
	export CXX=hipcc

	local mycmakeargs=(
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocsparse"
	)

	cmake_src_configure
}
