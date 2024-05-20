# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake llvm

LLVM_MAX_SLOT=15

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
	"${FILESDIR}/${PN}-5.0.1-cmake-install-paths.patch"
	"${FILESDIR}/${PN}-4.3.0_no-aqlprofiler.patch"
)

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

COMMON_DEPEND="dev-libs/elfutils"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/roct-thunk-interface-${PV}
	>=dev-libs/rocm-device-libs-${PV}
	<=dev-libs/rocm-device-libs-6.0
	sys-devel/clang
	sys-devel/lld"
BDEPEND="app-editors/vim-core"
	# vim-core is needed for "xxd"

CMAKE_BUILD_TYPE=Release

src_prepare() {
	# ... otherwise system llvm/clang is used ...
	sed -e "/find_package(Clang REQUIRED HINTS /s:\${CMAKE_INSTALL_PREFIX}/llvm \${CMAKE_PREFIX_PATH}/llvm PATHS /opt/rocm/llvm:$(get_llvm_prefix ${LLVM_MAX_SLOT}):" -i image/blit_src/CMakeLists.txt || die

	# Gentoo installs "*.bc" to "/usr/lib" instead of a "[path]/bitcode" directory ...
	sed -e "s:/opt/rocm/amdgcn/bitcode:${EPREFIX}/usr/lib/amdgcn/bitcode:" -i image/blit_src/CMakeLists.txt || die

	cmake_src_prepare
}
