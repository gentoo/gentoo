# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic prefix

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/"
	inherit git-r3
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/roc-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/ROCm-OpenCL-Runtime-rocm-${PV}"
fi

DESCRIPTION="Radeon Open Compute OpenCL Compatible Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"

LICENSE="Apache-2.0 MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocr-runtime-${PV}
	>=dev-libs/rocclr-${PV}
	>=dev-libs/rocm-comgr-${PV}
	>=dev-libs/rocm-device-libs-${PV}
	>=virtual/opencl-3
	media-libs/mesa"
DEPEND="${RDEPEND}
	dev-lang/ocaml
	dev-ml/findlib"
BDEPEND=">=dev-util/rocm-cmake-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-3.7.0-change-install-location.patch"
	"${FILESDIR}/${PN}-3.5.0-do-not-install-libopencl.patch"
	"${FILESDIR}/${PN}-3.10.0-add-rocclr-include-directories.patch"
	"${FILESDIR}/${PN}-3.7.0-amdocl64icd.patch"
)

src_prepare() {
	# Remove "clinfo" - use "dev-util/clinfo" instead
	[ -d tools/clinfo ] && rm -rf tools/clinfo || die

	cmake_src_prepare

	hprefixify amdocl/CMakeLists.txt
}

src_configure() {
	# Reported upstream: https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/issues/120
	append-cflags -fcommon

	local mycmakeargs=(
		-DUSE_COMGR_LIBRARY=yes
		-DROCclr_DIR="${EPREFIX}/usr/include/rocclr"
		-DLIBROCclr_STATIC_DIR="${EPREFIX}/usr/lib/cmake/rocclr"
	)
	cmake_src_configure
}

src_install() {
	cd "${BUILD_DIR}" || die
	insinto /etc/OpenCL/vendors
	doins amdocl64.icd
	insinto /usr/lib64
	doins lib/libamdocl64.so
}
