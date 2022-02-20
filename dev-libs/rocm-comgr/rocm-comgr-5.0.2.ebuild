# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake prefix

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/"
	inherit git-r3
	S="${WORKDIR}/${P}/lib/comgr"
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ROCm-CompilerSupport-rocm-${PV}/lib/comgr"
	KEYWORDS="~amd64"
fi

PATCHES=(
	"${FILESDIR}/${PN}-4.5.2-dependencies.patch"
)

DESCRIPTION="Radeon Open Compute Code Object Manager"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocm-device-libs-${PV}
	>=sys-devel/llvm-roc-${PV}:="
DEPEND="${RDEPEND}"

CMAKE_BUILD_TYPE=Release

src_prepare() {
	sed '/sys::path::append(HIPPath/s,"hip","",' -i src/comgr-env.cpp || die
	sed '/sys::path::append(LLVMPath/s,"llvm","lib/llvm/roc",' -i src/comgr-env.cpp || die
	sed '/Args.push_back(HIPIncludePath/,+1d' -i src/comgr-compiler.cpp || die
	sed '/Args.push_back(ROCMIncludePath/,+1d' -i src/comgr-compiler.cpp || die # ROCM and HIPIncludePath is now /usr, which disturb the include order
	eapply $(prefixify_ro "${FILESDIR}"/${PN}-5.0-rocm_path.patch)
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLLD_DIR="${EPREFIX}/usr/lib/llvm/roc/lib/cmake/lld"
		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/roc/lib/cmake/llvm"
		-DClang_DIR="${EPREFIX}/usr/lib/llvm/roc/lib/cmake/clang"
		-DCMAKE_STRIP=""  # disable stripping defined at lib/comgr/CMakeLists.txt:58
	)
	cmake_src_configure
}
