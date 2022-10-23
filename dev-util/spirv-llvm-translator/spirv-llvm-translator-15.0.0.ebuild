# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT="15"
MY_PN="SPIRV-LLVM-Translator"
MY_P="${MY_PN}-${PV}"

inherit cmake flag-o-matic llvm

DESCRIPTION="Bi-directional translator between SPIR-V and LLVM IR"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="UoI-NCSA"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="test +tools"
REQUIRED_USE="test? ( tools )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/spirv-headers
	sys-devel/clang:${SLOT}
	sys-devel/llvm:${SLOT}
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	test? ( dev-python/lit )
"

src_prepare() {
	append-flags -fPIC
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCCACHE_ALLOWED="OFF"
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${BROOT}/usr/include/spirv"
		-DLLVM_BUILD_TOOLS=$(usex tools "ON" "OFF")
		-DLLVM_SPIRV_INCLUDE_TESTS=$(usex test "ON" "OFF")
		-Wno-dev
	)

	cmake_src_configure
}

src_test() {
	lit "${BUILD_DIR}/test" || die
}
