# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# spirv-headers-tag.conf
HASH_SPIRV="9268f3057354a2cb65991ba5f38b16d81e803692"
LLVM_COMPAT=( 22 )
MY_PN="SPIRV-LLVM-Translator"
EGIT_COMMIT=93ca5f905e3c1e9359e77d8b3191999bd5ce2c93
MY_P=${MY_PN}-${EGIT_COMMIT}

inherit cmake-multilib flag-o-matic llvm-r2 multiprocessing

DESCRIPTION="Bi-directional translator between SPIR-V and LLVM IR"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
SRC_URI="
	https://github.com/KhronosGroup/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.tar.gz
	https://github.com/KhronosGroup/SPIRV-Headers/archive/${HASH_SPIRV}.tar.gz
		-> spirv-headers-${HASH_SPIRV}.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="UoI-NCSA"
SLOT="$(ver_cut 1)"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/spirv-tools[${MULTILIB_USEDEP}]
	llvm-core/llvm:${SLOT}=[${MULTILIB_USEDEP}]
"
# We need to use currently newer spirv-headers, as stable release is too old..
# DEPEND="${RDEPEND}
#	>=dev-util/spirv-headers-1.4.313.0
# "
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

	# do not force a specific LLVM version to find_package(), this only
	# causes issues and we force a specific path anyway
	sed -i -e '/find_package/s:${BASE_LLVM_VERSION}::' CMakeLists.txt || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCCACHE_ALLOWED="OFF"
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix)"
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${WORKDIR}/SPIRV-Headers-${HASH_SPIRV}"
		-DLLVM_SPIRV_INCLUDE_TESTS=$(usex test "ON" "OFF")
		-Wno-dev
	)

	cmake_src_configure
}

multilib_src_test() {
	lit -vv "-j${LIT_JOBS:-$(makeopts_jobs)}" "${BUILD_DIR}/test" || die
}
