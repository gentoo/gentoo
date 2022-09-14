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
IUSE="test +threads"
RESTRICT="!test? ( test )"

BUILD_DIR="${S}/build"

DEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}
	>=sys-devel/lld-${LLVM_MAX_SLOT}
	<sys-devel/lld-$((${LLVM_MAX_SLOT} + 1))
	sys-devel/llvm:${LLVM_MAX_SLOT}
	>=sys-libs/zlib-1.2.12
"

RDEPEND="
	${DEPEND}
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
		-DZIG_SHARED_LLVM=ON
		-DZIG_SINGLE_THREADED="$(usex !threads)"
		-DCMAKE_PREFIX_PATH=$(get_llvm_prefix ${LLVM_MAX_SLOT})
		-DCMAKE_INSTALL_PREFIX="${BUILD_DIR}/stage3"
	)

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	./stage3/bin/zig build test -Dstatic-llvm=false -Denable-llvm=true || die
}

src_install() {
	cd "${BUILD_DIR}" || die
	DESTDIR="${D}" ./zig2 build install -Denable-stage1=true -Dstatic-llvm=false -Denable-llvm=true --prefix "${EPREFIX}"/usr || die
	dodoc ../README.md
}

# see https://github.com/ziglang/zig/issues/3382
QA_FLAGS_IGNORED="usr/bin/zig"

pkg_postinst() {
	elog "If you want to use stage1 backend, use -fstage1 flag"
}
