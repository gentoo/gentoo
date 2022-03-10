# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic prefix

DESCRIPTION="Radeon Open Compute OpenCL Compatible Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"
SRC_URI="https://github.com/ROCm-Developer-Tools/ROCclr/archive/rocm-${PV}.tar.gz -> rocclr-${PV}.tar.gz
	https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/rocm-${PV}.tar.gz -> rocm-opencl-runtime-${PV}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

RDEPEND=">=dev-libs/rocr-runtime-${PV}
	>=dev-libs/rocm-comgr-${PV}
	>=dev-libs/rocm-device-libs-${PV}
	>=virtual/opencl-3
	media-libs/mesa"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-util/rocm-cmake-${PV}
	media-libs/glew
	"

PATCHES=(
	"${FILESDIR}/${PN}-4.5.2-remove-clinfo.patch"
	"${FILESDIR}/${PN}-3.5.0-do-not-install-libopencl.patch"
)

S="${WORKDIR}/ROCm-OpenCL-Runtime-rocm-${PV}"
S1="${WORKDIR}/ROCclr-rocm-${PV}"

CMAKE_BUILD_TYPE=Release

src_prepare() {
	# Remove "clinfo" - use "dev-util/clinfo" instead
	[ -d tools/clinfo ] && rm -rf tools/clinfo || die

	cmake_src_prepare

	hprefixify amdocl/CMakeLists.txt

	local S="${S1}"
	local CMAKE_USE_DIR="${S1}"
	# Bug #753377
	local PATCHES=()
	BUILD_DIR="${S1}_build" cmake_src_prepare
}

src_configure() {
	# configure ROCclr
	CMAKE_USE_DIR="${S1}"
	local mycmakeargs=(
		-Wno-dev
		-DAMD_OPENCL_PATH="${WORKDIR}/ROCm-OpenCL-Runtime-rocm-${PV}"
	)
	BUILD_DIR="${S1}_build" cmake_src_configure

	# Reported upstream: https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/issues/120
	append-cflags -fcommon

	CMAKE_USE_DIR="${S}"
	local mycmakeargs=(
		-Wno-dev
		-DROCCLR_PATH="${S1}"
		-DAMD_OPENCL_PATH="${S}"
		-DROCM_PATH="${EPREFIX}/usr"
	)
	cmake_src_configure
}

src_compile() {
	local S="${S1}"
	BUILD_DIR="${S1}_build" cmake_src_compile

	local S="${S}"
	cmake_src_compile
}

src_install() {
	insinto /etc/OpenCL/vendors
	doins config/amdocl64.icd

	cd "${BUILD_DIR}" || die
	insinto /usr/lib64
	doins amdocl/libamdocl64.so
	doins tools/cltrace/libcltrace.so
}
