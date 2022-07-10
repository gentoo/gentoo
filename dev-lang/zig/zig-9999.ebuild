# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
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

LICENSE="MIT"
SLOT="0"
IUSE="test +stage2 +threads"
RESTRICT="!test? ( test )"

BUILD_DIR="${S}/build"

RDEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}
	>=sys-devel/lld-${LLVM_MAX_SLOT}
	<sys-devel/lld-$((${LLVM_MAX_SLOT} + 1))
	sys-devel/llvm:${LLVM_MAX_SLOT}
	>=sys-libs/zlib-1.2.12
"
DEPEND="${RDEPEND}"

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

# see https://github.com/ziglang/zig/wiki/Troubleshooting-Build-Issues#high-memory-requirements
CHECKREQS_MEMORY="10G"

# see https://github.com/ziglang/zig/issues/11137
PATCHES=( "${FILESDIR}/${P}-stage2-fix.patch" )

pkg_setup() {
	llvm_pkg_setup
	check-reqs_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DZIG_USE_CCACHE=OFF
		-DZIG_PREFER_CLANG_CPP_DYLIB=ON
		-DZIG_SINGLE_THREADED="$(usex threads OFF ON)"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use stage2 ; then
		cd "${BUILD_DIR}" || die
		./zig build -p stage2 -Dstatic-llvm=false -Denable-llvm=true -Dsingle-threaded="$(usex threads false true)" || die
	fi
}

src_test() {
	cd "${BUILD_DIR}" || die
	./zig build test || die
}

src_install() {
	cmake_src_install

	if use stage2 ; then
		cd "${BUILD_DIR}" || die
		mv ./stage2/bin/zig zig-stage2 || die
		dobin zig-stage2
	fi
}

# see https://github.com/ziglang/zig/issues/3382
QA_FLAGS_IGNORED="/usr/bin/zig-stage2"

pkg_postinst() {
	use stage2 && elog "You enabled stage2 USE flag, Zig stage1 was installed as /usr/bin/zig, Zig stage2 was installed as /usr/bin/zig-stage2"
}
