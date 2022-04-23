# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake

inherit cmake-multilib flag-o-matic llvm

MY_PN="SPIRV-LLVM-Translator"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Bi-directional translator between SPIR-V and LLVM IR"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-rename-OpConstFunctionPointerINTEL.patch.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="UoI-NCSA"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64"
IUSE="test +tools"

REQUIRED_USE="test? ( tools )"
RESTRICT="!test? ( test )"

RDEPEND="sys-devel/clang:${SLOT}=[${MULTILIB_USEDEP}]
	dev-util/spirv-headers"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-python/lit )"

LLVM_MAX_SLOT="${SLOT}"

PATCHES=(
	"${WORKDIR}"/${P}-rename-OpConstFunctionPointerINTEL.patch
)

src_prepare() {
	append-flags -fPIC
	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${BROOT}/usr/include/spirv"
		-DLLVM_BUILD_TOOLS=$(usex tools "ON" "OFF")
		-DLLVM_SPIRV_INCLUDE_TESTS=$(usex test "ON" "OFF")
	)
	cmake_src_configure
}

multilib_src_test() {
	# Some tests fail on amd64 when ABI==x86
	if multilib_is_native_abi; then
		lit "${BUILD_DIR}/test" || die "Error running tests for ABI ${ABI}"
	fi
}
