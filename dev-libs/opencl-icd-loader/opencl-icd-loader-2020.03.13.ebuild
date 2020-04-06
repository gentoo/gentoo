# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

MY_PN="OpenCL-ICD-Loader"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Official Khronos OpenCL ICD Loader"
HOMEPAGE="https://github.com/KhronosGroup/OpenCL-ICD-Loader"
SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="dev-util/opencl-headers"
RDEPEND="${DEPEND}
	app-eselect/eselect-opencl"

S="${WORKDIR}/${MY_P}"

multilib_src_configure() {
	local ocl_dir="/usr/$(get_libdir)/OpenCL/vendors/${PN}"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${ocl_dir}"
		-DCMAKE_INSTALL_LIBDIR="${ocl_dir}"
		-DBUILD_TESTING=$(usex test)
		-DOPENCL_ICD_LOADER_HEADERS_DIR="${ocl_dir}/include"
	)
	cmake_src_configure
}

multilib_src_test() {
	OCL_ICD_FILENAMES="${BUILD_DIR}/test/driver_stub/libOpenCLDriverStub.so" \
	cmake_src_test
}

pkg_postinst() {
	eselect opencl set --use-old "${PN}"
}
