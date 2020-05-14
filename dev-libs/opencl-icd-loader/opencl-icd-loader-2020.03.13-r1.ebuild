# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib flag-o-matic

MY_PN="OpenCL-ICD-Loader"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Official Khronos OpenCL ICD Loader"
HOMEPAGE="https://github.com/KhronosGroup/OpenCL-ICD-Loader"
SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="dev-util/opencl-headers
	!app-eselect/eselect-opencl
	!dev-libs/ocl-icd"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Until the next upstream release. Bug #716410
	if use test; then
		append-cflags $(test-flags-CC -fcommon)
	fi

	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DOPENCL_ICD_LOADER_HEADERS_DIR="${EPREFIX}/usr/include"
	)
	cmake_src_configure
}

multilib_src_test() {
	OCL_ICD_FILENAMES="${BUILD_DIR}/test/driver_stub/libOpenCLDriverStub.so" \
	cmake_src_test
}
