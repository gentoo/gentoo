# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib llvm vcs-snapshot

EGIT_COMMIT="94af090661d7c953c516c97a25ed053c744a0737"

DESCRIPTION="OpenCL-oriented thin wrapper library around clang"
HOMEPAGE="https://github.com/intel/opencl-clang"
SRC_URI="https://github.com/intel/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="UoI-NCSA"
SLOT="8"
KEYWORDS="~amd64"

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
	cmake-utils_src_configure
}
