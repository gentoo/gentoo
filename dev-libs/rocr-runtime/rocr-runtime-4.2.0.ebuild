# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCR-Runtime/"
	inherit git-r3
	S="${WORKDIR}/${P}/src"
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROCR-Runtime/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ROCR-Runtime-rocm-${PV}/src"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCR-Runtime"
PATCHES=(
	"${FILESDIR}/${PN}-4.1.0-cmake-install-paths.patch"
)

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

COMMON_DEPEND="sys-process/numactl
	dev-libs/elfutils:="
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/roct-thunk-interface-${PV}
	>=dev-libs/rocm-device-libs-${PV}"
BDEPEND="app-editors/vim-core"
	# vim-core is needed for "xxd"

src_prepare() {
	sed -e "s:get_version ( \"1.0.0\" ):get_version ( \"${PV}\" ):" -i CMakeLists.txt || die

	# ... otherwise system llvm/clang is used ...
	sed -e "s:find_package(Clang REQUIRED HINTS \${CMAKE_INSTALL_PREFIX}/llvm \${CMAKE_PREFIX_PATH}/llvm PATHS /opt/rocm/llvm ):find_package(Clang REQUIRED HINTS /usr/lib/llvm/roc ):" -i image/blit_src/CMakeLists.txt || die

	# Gentoo installs "*.bc" to "/usr/lib" instead of a "[path]/bitcode" directory ...
	sed -e "s:/opt/rocm/amdgcn/bitcode:/usr/lib/amdgcn/bitcode:" -i image/blit_src/CMakeLists.txt || die

	cmake_src_prepare
}
