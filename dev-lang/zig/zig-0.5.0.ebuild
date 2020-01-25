# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake llvm

DESCRIPTION="A robust, optimal, and maintainable programming language"
HOMEPAGE="https://ziglang.org/"
LICENSE="MIT"
SLOT="0"
IUSE="+experimental"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/ziglang/zig.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ziglang/zig/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM BPF Hexagon Lanai Mips MSP430 NVPTX
	PowerPC Sparc SystemZ WebAssembly X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
# According to zig's author, zig builds that do not support all targets are not
# supported by the upstream project.
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]}

RDEPEND="
	sys-devel/llvm:9
	!experimental? ( sys-devel/llvm:9[${LLVM_TARGET_USEDEPS// /,}] )
	sys-devel/clang:9
"

DEPEND="${RDEPEND}"

LLVM_MAX_SLOT=9

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

src_prepare() {
	if use experimental; then
		sed -i '/^NEED_TARGET(/d' cmake/Findllvm.cmake || die "unable to modify cmake/Findllvm.cmake"
	fi

	sed -i 's/--prefix "${CMAKE_INSTALL_PREFIX}"/--prefix ".\/${CMAKE_INSTALL_PREFIX}"/' CMakeLists.txt || \
	    die "unable to fix install path"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCLANG_INCLUDE_DIRS="$(llvm-config --includedir)"
		-DCLANG_LIBDIRS="$(llvm-config --libdir)"
	)

	cmake_src_configure
}
