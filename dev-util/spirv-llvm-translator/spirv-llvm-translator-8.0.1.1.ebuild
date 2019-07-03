# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib flag-o-matic llvm

MY_PN="SPIRV-LLVM-Translator"
MY_PV="$(ver_rs 3 -)"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Bi-directional translator between SPIR-V and LLVM IR"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UoI-NCSA"
SLOT="8"
KEYWORDS="~amd64"
IUSE="test"

S="${WORKDIR}/${MY_P}"

COMMON="sys-devel/llvm:8=[${MULTILIB_USEDEP}]"
DEPEND="${COMMON}
	test? ( dev-python/lit )"
RDEPEND="${COMMON}"

LLVM_MAX_SLOT=8

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.0.1-no_pkgconfig_files.patch
)

src_prepare() {
	append-flags -fPIC
	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix)"
		$(usex test "-DLLVM_INCLUDE_TESTS=ON" "")
	)
	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile llvm-spirv
}

multilib_src_install() {
	cmake-utils_src_install
	# CMake does not install the executable so do it by hand
	if multilib_is_native_abi; then
		exeinto "$(get_llvm_prefix)"/bin
		doexe "${BUILD_DIR}"/tools/llvm-spirv/llvm-spirv
	fi
}

multilib_src_test() {
	# TODO: figure out why some tests fail on amd64 when ABI==x86
	if multilib_is_native_abi; then
		lit "${BUILD_DIR}/test" || die "Error running tests for ABI ${ABI}"
	fi
}
