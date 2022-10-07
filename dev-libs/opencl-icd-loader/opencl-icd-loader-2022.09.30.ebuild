# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

MY_PN="OpenCL-ICD-Loader"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Official Khronos OpenCL ICD Loader"
HOMEPAGE="https://github.com/KhronosGroup/OpenCL-ICD-Loader"
SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="!dev-libs/ocl-icd"
DEPEND="${RDEPEND}
	>=dev-util/opencl-headers-${PV}"

S="${WORKDIR}/${MY_P}"

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

multilib_src_test() {
	local -x OCL_ICD_FILENAMES="${BUILD_DIR}/test/driver_stub/libOpenCLDriverStub.so"
	local -x OCL_ICD_VENDORS="/dev/null"
	cmake_src_test
}
