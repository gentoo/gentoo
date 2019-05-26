# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

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
	=sys-devel/llvm-8*
	!experimental? ( =sys-devel/llvm-8*[${LLVM_TARGET_USEDEPS// /,}] )
"

DEPEND="${RDEPEND}"

src_prepare() {
	if use experimental; then
		sed -i '/^NEED_TARGET(/d' cmake/Findllvm.cmake || die "unable to modify cmake/Findllvm.cmake"
	fi

	sed -i 's/--prefix "${CMAKE_INSTALL_PREFIX}"/--prefix "${DESTDIR}${CMAKE_INSTALL_PREFIX}"/' CMakeLists.txt || \
	    die "unable to fix install path"

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DDESTDIR="${T}"
	)

	cmake-utils_src_configure
}

src_install() {
	cp -r "${T}/usr" "${ED}" || die "unable to copy /usr"

	cmake-utils_src_install

	rm -rf "${ED}/var" || die "unable to remove /var"
}
