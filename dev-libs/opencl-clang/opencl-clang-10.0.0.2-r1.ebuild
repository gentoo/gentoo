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
SLOT="10"
KEYWORDS="~amd64"

S="${WORKDIR}/${MY_P}"

# Force a rebuild of this package once clang has been updated from 10.0.0 to 10.0.1
# in order to work around Bug #743992. Hopefully a one-time thing.
DEPEND="~sys-devel/clang-10.0.1:10=[static-analyzer,${MULTILIB_USEDEP}]
	sys-devel/llvm:10=[${MULTILIB_USEDEP}]
	>=dev-util/spirv-llvm-translator-10.0.0_p20200909:10=[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

LLVM_MAX_SLOT=10

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.0-clang_library_dir.patch
	"${FILESDIR}"/${PN}-10.0.0.1_find-llvm-tblgen.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		-DCLANG_LIBRARY_DIRS="${EPREFIX}"/usr/lib/clang
	)
	cmake_src_configure
}
