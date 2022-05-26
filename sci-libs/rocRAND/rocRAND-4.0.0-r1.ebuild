# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Generate pseudo-random and quasi-random numbers"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocRAND/archive/rocm-${PV}.tar.gz -> rocRAND-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}
	=dev-util/rocm-cmake-$(ver_cut 1-2)*"

S="${WORKDIR}/rocRAND-rocm-${PV}"

src_prepare() {
	sed -r -e "s:(hip|roc)rand/lib:\${CMAKE_INSTALL_LIBDIR}:" \
		-e "s:(hip|roc)rand/include:include/\1rand:" \
		-e "/INSTALL_RPATH/d" -i library/CMakeLists.txt || die

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
	# do not rerun cmake and the build process in src_install
	sed '/RERUN/,+1d' -i "${BUILD_DIR}"/build.ninja || die
}
