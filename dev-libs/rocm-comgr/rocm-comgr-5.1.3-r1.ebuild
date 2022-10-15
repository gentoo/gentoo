# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake llvm prefix

LLVM_MAX_SLOT=14

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
	"${FILESDIR}/${PN}-5.1.3-Find-CLANG_RESOURCE_DIR.patch"
	"${FILESDIR}/${PN}-5.1.3-clang-link.patch"
	"${FILESDIR}/${PN}-5.1.3-clang-fix-include.patch"
	"${FILESDIR}/${PN}-5.1.3-rocm-path.patch"
	"${FILESDIR}/0001-COMGR-changes-needed-for-upstream-llvm.patch"
)

DESCRIPTION="Radeon Open Compute Code Object Manager"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocm-device-libs-${PV}
	sys-devel/clang:${LLVM_MAX_SLOT}=
	sys-devel/clang-runtime:=
	sys-devel/lld:${LLVM_MAX_SLOT}="
DEPEND="${RDEPEND}"

CMAKE_BUILD_TYPE=Release

src_prepare() {
	sed '/sys::path::append(HIPPath/s,"hip","",' -i src/comgr-env.cpp || die
	sed "/return LLVMPath;/s,LLVMPath,llvm::SmallString<128>(\"$(get_llvm_prefix ${LLVM_MAX_SLOT})\")," -i src/comgr-env.cpp || die
	sed '/Args.push_back(HIPIncludePath/,+1d' -i src/comgr-compiler.cpp || die
	sed '/Args.push_back(ROCMIncludePath/,+1d' -i src/comgr-compiler.cpp || die # ROCM and HIPIncludePath is now /usr, which disturb the include order
	eapply $(prefixify_ro "${FILESDIR}"/${PN}-5.0-rocm_path.patch)
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		-DCMAKE_STRIP=""  # disable stripping defined at lib/comgr/CMakeLists.txt:58
	)
	cmake_src_configure
}
