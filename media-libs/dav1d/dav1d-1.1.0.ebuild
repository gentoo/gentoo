# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://code.videolan.org/videolan/dav1d"
	inherit git-r3
else
	SRC_URI="https://code.videolan.org/videolan/dav1d/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

inherit meson-multilib

DESCRIPTION="dav1d is an AV1 Decoder :)"
HOMEPAGE="https://code.videolan.org/videolan/dav1d"

LICENSE="BSD-2"
# Check SONAME on version bumps!
SLOT="0/6"
IUSE="+8bit +10bit +asm test xxhash"
RESTRICT="!test? ( test )"

ASM_DEPEND=">=dev-lang/nasm-2.15.05"
BDEPEND="asm? (
		abi_x86_32? ( ${ASM_DEPEND} )
		abi_x86_64? ( ${ASM_DEPEND} )
	)
	xxhash? ( dev-libs/xxhash )"

DOCS=( README.md doc/PATENTS THANKS.md )

multilib_src_configure() {
	local -a bits=()
	use 8bit  && bits+=( 8 )
	use 10bit && bits+=( 16 )

	local enable_asm
	if [[ ${MULTILIB_ABI_FLAG} == abi_x86_x32 ]]; then
		enable_asm=false
	else
		enable_asm=$(usex asm true false)
	fi

	local emesonargs=(
		-Dbitdepths=$(IFS=,; echo "${bits[*]}")
		-Denable_asm=${enable_asm}
		$(meson_use test enable_tests)
		$(meson_feature xxhash xxhash_muxer)
	)
	meson_src_configure
}

multilib_src_test() {
	if multilib_is_native_abi ; then
		meson_src_test
	fi
}
