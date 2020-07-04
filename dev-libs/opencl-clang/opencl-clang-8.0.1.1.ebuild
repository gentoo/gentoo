# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib llvm

MY_PV="$(ver_rs 3 -)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="OpenCL-oriented thin wrapper library around clang"
HOMEPAGE="https://github.com/intel/opencl-clang"
SRC_URI="https://github.com/intel/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UoI-NCSA"
SLOT="8"
KEYWORDS="~amd64"

S="${WORKDIR}/${MY_P}"

BDEPEND="dev-vcs/git"
COMMON="sys-devel/clang:8=[static-analyzer,${MULTILIB_USEDEP}]"
DEPEND="${COMMON}
	dev-util/spirv-llvm-translator:8=[${MULTILIB_USEDEP}]"
RDEPEND="${COMMON}"

LLVM_MAX_SLOT=8

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.0-clang_library_dir.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		-DCLANG_LIBRARY_DIRS="${EPREFIX}"/usr/lib/clang
	)
	cmake_src_configure
}
