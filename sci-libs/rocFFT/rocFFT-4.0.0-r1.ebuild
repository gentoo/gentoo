# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic check-reqs

DESCRIPTION="Next generation FFT implementation for ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocFFT"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocFFT/archive/rocm-${PV}.tar.gz -> rocFFT-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}"

CHECKREQS_MEMORY="28G"

S="${WORKDIR}/rocFFT-rocm-${PV}"

src_prepare() {
	sed -e "s/PREFIX rocfft//" \
		-e "/rocm_install_symlink_subdir/d" \
		-e "/<INSTALL_INTERFACE/s,include,include/rocFFT," \
		-i library/src/CMakeLists.txt || die

	sed -e "/rocm_install_symlink_subdir/d" \
		-e "$!N;s:PREFIX\n  rocfft:# PREFIX rocfft\n:;P;D" \
		-i library/src/device/CMakeLists.txt || die

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
		-Wno-dev
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocFFT/"
	)

	cmake_src_configure
}
