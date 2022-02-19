# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SCM=""
if [[ "${PV}" == "9999" ]]; then
	SCM="git-r3"
	EGIT_REPO_URI="https://code.videolan.org/videolan/dav1d"
else
	SRC_URI="https://code.videolan.org/videolan/dav1d/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~sparc x86"
fi

inherit ${SCM} meson-multilib

DESCRIPTION="dav1d is an AV1 Decoder :)"
HOMEPAGE="https://code.videolan.org/videolan/dav1d"

LICENSE="BSD-2"
SLOT="0/5"
IUSE="+8bit +10bit +asm test xxhash"
RESTRICT="!test? ( test )"

ASM_DEPEND=">=dev-lang/nasm-2.15.05"
BDEPEND="asm? (
		abi_x86_32? ( ${ASM_DEPEND} )
		abi_x86_64? ( ${ASM_DEPEND} )
	)
	xxhash? ( dev-libs/xxhash )
	"

DOCS=( README.md doc/PATENTS THANKS.md )
PATCHES=( "${FILESDIR}"/build-avoid-meson-s-symbols_have_underscore_prefix.patch )

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
		-D bitdepths=$(IFS=,; echo "${bits[*]}")
		-D enable_asm=${enable_asm}
		-D enable_tests=$(usex test true false)
		-D xxhash_muxer=$(usex xxhash enabled disabled)
	)
	meson_src_configure
}

multilib_src_test() {
	if multilib_is_native_abi ; then
		meson_src_test
	fi
}
