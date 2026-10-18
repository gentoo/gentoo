# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.95"
inherit cargo toolchain-funcs

DESCRIPTION="A Modern Linker"
HOMEPAGE="https://github.com/rui314/mold"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/rui314/mold.git"
	inherit git-r3
else
	SRC_URI="https://github.com/rui314/mold/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	# -alpha: alpha support was dropped upstream:
	# https://github.com/rui314/mold/commit/3711ddb95e23c12991f6b8c7bfeba4f1421d19d4
	KEYWORDS="-alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~riscv ~sparc ~x86"
fi

# mold (MIT)
#  - xxhash (BSD-2)
#  - siphash ( MIT CC0-1.0 )
LICENSE="MIT BSD-2 CC0-1.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/zstd:=
	virtual/zlib:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( llvm-core/clang:* )
"

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_prepare() {
	default

	# Needs unpackaged dwarfdump
	rm tests/{{dead,compress}-debug-sections,compressed-debug-info}.sh || die

	# Heavy tests, need qemu
	rm tests/gdb-index-{compress-output,dwarf{2,3,4,5}}.sh || die
	rm tests/lto-{archive,dso,gcc,llvm,version-script}.sh || die

	# Sandbox sadness
	rm tests/run.sh || die
	sed -i 's|`pwd`/mold-wrapper.so|"& ${LD_PRELOAD}"|' \
		tests/mold-wrapper{,2}.sh || die

	# Fails if binutils errors out on textrels by default
	rm tests/textrel.sh tests/textrel2.sh || die

	# Fails with -mno-direct-extern-access
	rm tests/copyrel-{protected,alignment,norelro}.sh tests/nocopyreloc.sh || die
	# TODO
	rm tests/abs-reloc-promotion.sh tests/arch-x86_64-z-dynamic-undefined-weak.sh || die
	rm tests/linker-script-group-as-needed.sh tests/gdb-index-dwarf64.sh || die
	rm tests/mold-wrapper2.sh || die

	# Don't let the default linker config affect the tests, bug #974439
	sed -e 's:\(clang\|clang\+\+\):\1 --no-default-config:' -i tests/*.sh || die

	# static-pie tests require glibc built with static-pie support
	if ! has_version -d 'sys-libs/glibc[static-pie(+)]'; then
		rm tests/{,ifunc-}static-pie.sh || die
	fi
}

src_configure() {
	export ZSTD_SYS_USE_PKG_CONFIG=1

	local myfeatures=(
		mold/system-allocator
	)

	cargo_src_configure
}

src_test() {
	export TEST_CC="$(tc-getCC)" TEST_GCC="$(tc-getCC)" \
		TEST_CXX="$(tc-getCXX)" TEST_GXX="$(tc-getCXX)"
	cargo_src_test
}

src_install() {
	dobin "$(cargo_target_dir)"/${PN}

	doman docs/mold.1
	dodoc docs/mold.md

	dosym ${PN} /usr/bin/ld.${PN}
	dosym ${PN} /usr/bin/ld64.${PN}
	dosym -r /usr/bin/${PN} /usr/libexec/${PN}/ld
}
