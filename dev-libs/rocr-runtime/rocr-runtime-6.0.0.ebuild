# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic llvm

LLVM_MAX_SLOT=17

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
	"${FILESDIR}/${PN}-4.3.0_no-aqlprofiler.patch"
)

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="debug"

COMMON_DEPEND="dev-libs/elfutils
	x11-libs/libdrm"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/roct-thunk-interface-${PV}
	>=dev-libs/rocm-device-libs-${PV}
	sys-devel/clang
	sys-devel/lld"
RDEPEND="${DEPEND}"
BDEPEND="app-editors/vim-core"
	# vim-core is needed for "xxd"

src_prepare() {
	# ... otherwise system llvm/clang is used ...
	sed -e "s:find_package(Clang REQUIRED HINTS \${CMAKE_INSTALL_PREFIX}/llvm \${CMAKE_PREFIX_PATH}/llvm PATHS /opt/rocm/llvm ):find_package(Clang REQUIRED HINTS /usr/lib/llvm/roc ):" -i image/blit_src/CMakeLists.txt || die

	# Gentoo installs "*.bc" to "/usr/lib" instead of a "[path]/bitcode" directory ...
	sed -e "s:-O2:--rocm-path=${EPREFIX}/usr/lib/ -O2:" -i image/blit_src/CMakeLists.txt || die

	# internal version depends on git being present and random weird magic, otherwise fallback to incoherent default value
	# fix default value to be more better

	sed -i -e "s:1.7.0:${PV}:" CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	use debug || append-cxxflags "-DNDEBUG"
	local mycmakeargs=( -DINCLUDE_PATH_COMPATIBILITY=OFF )
	cmake_src_configure
}
