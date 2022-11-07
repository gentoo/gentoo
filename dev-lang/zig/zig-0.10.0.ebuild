# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
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

BUILD_DIR="${S}/build"

# Zig requires zstd and zlib compression support in LLVM, if using LLVM backend (non-LLVM backends don't require these).
# They are not required "on their own", so please don't add them here.
# You can check https://github.com/ziglang/zig-bootstrap in future, to see
# options that are passed to LLVM CMake building (excluding "static" ofc).
DEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}=
	sys-devel/lld:${LLVM_MAX_SLOT}=
	sys-devel/llvm:${LLVM_MAX_SLOT}=[zstd]
"

RDEPEND="
	${DEPEND}
	!dev-lang/zig-bin
"

# see https://github.com/ziglang/zig/issues/3382
# For now, Zig doesn't support CFLAGS/LDFLAGS/etc.
QA_FLAGS_IGNORED="usr/bin/zig"

# see https://ziglang.org/download/0.10.0/release-notes.html#Self-Hosted-Compiler
# 0.10.0 release - ~9.6 GiB, since we use compiler written in C++ for bootstrapping
# 0.11.0 release - ~2.8 GiB, since we will (at least according to roadmap) use self-hosted compiler
# (transpiled to C via C backend) for bootstrapping
CHECKREQS_MEMORY="10G"

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	llvm_pkg_setup
	check-reqs_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DZIG_USE_CCACHE=OFF
		-DZIG_SHARED_LLVM=ON
		-DCMAKE_PREFIX_PATH=$(get_llvm_prefix ${LLVM_MAX_SLOT})
	)

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	./zig2 build test -Dstatic-llvm=false -Denable-llvm=true -Dskip-non-native=true || die
}

pkg_postinst() {
	elog "0.10.0 release introduces self-hosted compiler for general use by default"
	elog "It means that your code can be un-compilable since this compiler has some new or removed features and new or fixed bugs"
	elog "Upstream recommends using stage1 if experiencing such breakage,"
	elog "until bugfix release 0.10.1 or release 0.11.0 where old compiler will be fully replaced"
	elog "You can use old compiler by using '-fstage1' flag"
	elog "Also see: https://ziglang.org/download/0.10.0/release-notes.html#Self-Hosted-Compiler"
	elog "and https://ziglang.org/download/0.10.0/release-notes.html#How-to-Upgrade"
}
