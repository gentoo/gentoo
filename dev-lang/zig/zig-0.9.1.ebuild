# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=13
inherit cmake llvm check-reqs

DESCRIPTION="A robust, optimal, and maintainable programming language"
HOMEPAGE="https://ziglang.org/"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/ziglang/zig.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ziglang/zig/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BUILD_DIR="${S}/build"

# According to zig's author, zig builds that do not support all targets are not
# supported by the upstream project.
ALL_LLVM_TARGETS=(
	AArch64 AMDGPU ARM AVR BPF Hexagon Lanai Mips MSP430 NVPTX
	PowerPC RISCV Sparc SystemZ WebAssembly X86 XCore
)
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS="${ALL_LLVM_TARGETS[@]}"

RDEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}
	>=sys-devel/lld-${LLVM_MAX_SLOT}
	<sys-devel/lld-$((${LLVM_MAX_SLOT} + 1))
	sys-devel/llvm:${LLVM_MAX_SLOT}[${LLVM_TARGET_USEDEPS// /,}]
"
DEPEND="${RDEPEND}"

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

# see https://github.com/ziglang/zig/wiki/Troubleshooting-Build-Issues#high-memory-requirements
CHECKREQS_MEMORY="10G"

src_configure() {
	local mycmakeargs=(
		-DZIG_USE_CCACHE=OFF
		-DZIG_PREFER_CLANG_CPP_DYLIB=ON
	)

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	./zig build test || die
}
