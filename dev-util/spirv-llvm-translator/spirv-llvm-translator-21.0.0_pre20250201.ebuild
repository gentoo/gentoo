# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 21 )

inherit cmake-multilib flag-o-matic llvm-r2 multiprocessing

EGIT_COMMIT=032f93c2c7081013b61524ba9681fa4239c9147e
MY_P=SPIRV-LLVM-Translator-${EGIT_COMMIT}
DESCRIPTION="Bi-directional translator between SPIR-V and LLVM IR"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
SRC_URI="
	https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="UoI-NCSA"
SLOT="$(ver_cut 1)"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/spirv-tools[${MULTILIB_USEDEP}]
	llvm-core/llvm:${SLOT}=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-util/spirv-headers-1.4.305
"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-python/lit
		llvm-core/clang:${SLOT}
	)
"

src_prepare() {
	sed -i -e '/BASE_LLVM/s:20:21:' CMakeLists.txt || die

	append-flags -fPIC
	cmake_src_prepare
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
