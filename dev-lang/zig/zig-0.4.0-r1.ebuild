# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils llvm

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
	sys-devel/llvm:8
	!experimental? ( sys-devel/llvm:8[${LLVM_TARGET_USEDEPS// /,}] )
"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/zig-0.4.0-r1-build-artifacts.patch"
	"${FILESDIR}/zig-0.4.0-r1-suppress-warnings.patch"
)

LLVM_MAX_SLOT=8

src_prepare() {
	if use experimental; then
		sed -i '/^NEED_TARGET(/d' cmake/Findllvm.cmake || die "unable to modify cmake/Findllvm.cmake"
	fi

	cmake-utils_src_prepare
}
