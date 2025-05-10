# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 18 )
MY_PN="SPIRV-LLVM-Translator"
MY_P="${MY_PN}-${PV}"

inherit cmake-multilib flag-o-matic llvm-r2 multiprocessing

DESCRIPTION="Bi-directional translator between SPIR-V and LLVM IR"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="UoI-NCSA"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/spirv-tools[${MULTILIB_USEDEP}]
	llvm-core/llvm:${SLOT}=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-util/spirv-headers-1.4.309.0
"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-python/lit
		llvm-core/clang:${SLOT}
	)
"

src_prepare() {
	append-flags -fPIC
	cmake_src_prepare

	# https://github.com/KhronosGroup/SPIRV-LLVM-Translator/pull/2555
	sed -i -e 's/%triple/x86_64-unknown-linux-gnu/' test/DebugInfo/X86/*.ll || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCCACHE_ALLOWED="OFF"
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix)"
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${ESYSROOT}/usr/include/spirv"
		-DLLVM_SPIRV_INCLUDE_TESTS=$(usex test "ON" "OFF")
		-Wno-dev
	)

	cmake_src_configure
}

multilib_src_test() {
	lit -vv "-j${LIT_JOBS:-$(makeopts_jobs)}" "${BUILD_DIR}/test" || die
}
