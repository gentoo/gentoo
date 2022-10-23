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
	SRC_URI="https://ziglang.org/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64"
fi

SRC_URI+=" https://codeberg.org/BratishkaErik/distfiles/media/branch/master/zig-0.9.1-fix-detecting-abi.patch"
LICENSE="MIT"
SLOT="0"
IUSE="test +threads"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${P}-fix-clang16.patch"
	"${FILESDIR}/${P}-fix-single-threaded.patch"
	"${FILESDIR}/${P}-fix-riscv.patch"
	"${FILESDIR}/${P}-fix-bad-hostname-segfault.patch"
	"${DISTDIR}/zig-0.9.1-fix-detecting-abi.patch"
)

BUILD_DIR="${S}/build"

DEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}=
	sys-devel/lld:${LLVM_MAX_SLOT}=
	sys-devel/llvm:${LLVM_MAX_SLOT}=
	>=sys-libs/zlib-1.2.12
"

RDEPEND="${DEPEND}
	!dev-lang/zig-bin
"

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

# see https://github.com/ziglang/zig/wiki/Troubleshooting-Build-Issues#high-memory-requirements
CHECKREQS_MEMORY="10G"

pkg_setup() {
	llvm_pkg_setup
	check-reqs_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DZIG_USE_CCACHE=OFF
		-DZIG_PREFER_CLANG_CPP_DYLIB=ON
		-DZIG_SINGLE_THREADED="$(usex !threads)"
		-DCMAKE_PREFIX_PATH=$(get_llvm_prefix ${LLVM_MAX_SLOT})
	)

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	./zig build test || die
}
