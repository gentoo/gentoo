# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT="16"
MY_PN="SPIRV-LLVM-Translator"
MY_P="${MY_PN}-${PV}"

inherit cmake flag-o-matic llvm multiprocessing

DESCRIPTION="Bi-directional translator between SPIR-V and LLVM IR"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="UoI-NCSA"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/spirv-tools
	sys-devel/llvm:${SLOT}=
"
DEPEND="${RDEPEND}
	dev-util/spirv-headers
"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-python/lit
		sys-devel/clang:${SLOT}
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-16.0.0-llvm-link-llvm-dylib.patch"
	"${FILESDIR}/${PN}-16.0.0-ld_library_path.patch"
)

src_prepare() {
	append-flags -fPIC
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCCACHE_ALLOWED="OFF"
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${ESYSROOT}/usr/include/spirv"
		-DLLVM_SPIRV_INCLUDE_TESTS=$(usex test "ON" "OFF")
		-Wno-dev
	)

	cmake_src_configure
}

src_test() {
	lit -vv "-j${LIT_JOBS:-$(makeopts_jobs)}" "${BUILD_DIR}/test" || die
}
