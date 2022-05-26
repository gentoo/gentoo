# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="HIP parallel primitives for developing performant GPU-accelerated code on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocPRIM"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocPRIM/archive/rocm-${PV}.tar.gz -> rocPRIM-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND=">=dev-util/hip-${PV}
	>=dev-util/rocm-cmake-${PV}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/rocPRIM-rocm-${PV}"

src_prepare() {
	# "hcc" is depcreated, new platform ist "rocclr"
	sed -e "/HIP_PLATFORM STREQUAL/s,hcc,rocclr," -i cmake/VerifyCompiler.cmake || die

	# Install according to FHS
	sed -e "/PREFIX rocprim/d" \
		-e "/INSTALL_INTERFACE/s,rocprim/include,include/rocprim," \
		-e "/DESTINATION/s,rocprim/include,include," \
		-e "/rocm_install_symlink_subdir(rocprim)/d" \
		-i rocprim/CMakeLists.txt || die

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
		-DAMDGPU_TARGETS="gfx803;gfx900;gfx906;gfx908"
		-DBUILD_TEST=OFF
		-DBUILD_BENCHMARK=OFF
	)

	cmake_src_configure
}
