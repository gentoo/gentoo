# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="c67648d41df00ea8ee9d701d17299b86f86f0321"
CMAKE_ECLASS=cmake

inherit cmake-multilib llvm

MY_PV="$(ver_rs 3 -)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="OpenCL-oriented thin wrapper library around clang"
HOMEPAGE="https://github.com/intel/opencl-clang"
SRC_URI="https://github.com/intel/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="UoI-NCSA"
SLOT="11"
KEYWORDS="~amd64"

# Force a rebuild of this package once clang has been updated from 10.0.0 to 10.0.1
# in order to work around Bug #743992. Hopefully a one-time thing.
DEPEND="
	>=dev-util/spirv-llvm-translator-11.0.0:11=[${MULTILIB_USEDEP}]
	~sys-devel/clang-11.1.0:11=[static-analyzer,${MULTILIB_USEDEP}]
	sys-devel/llvm:11=[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

LLVM_MAX_SLOT=11

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.0-clang_library_dir.patch
	"${FILESDIR}"/${PN}-10.0.0.1_find-llvm-tblgen.patch
	"${FILESDIR}"/${PN}-11.1.0_version.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		-DCLANG_LIBRARY_DIRS="${EPREFIX}"/usr/lib/clang
	)
	cmake_src_configure
}
