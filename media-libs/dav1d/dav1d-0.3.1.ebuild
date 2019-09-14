# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SCM=""
if [[ "${PV}" == "9999" ]]; then
	SCM="git-r3"
	EGIT_REPO_URI="https://code.videolan.org/videolan/dav1d"
else
	KEYWORDS="amd64 ~arm arm64 ppc ppc64 ~sparc x86"
	SRC_URI="https://code.videolan.org/videolan/dav1d/-/archive/${PV}/${P}.tar.bz2"
fi

inherit ${SCM} meson ninja-utils multilib-minimal

DESCRIPTION="dav1d is an AV1 Decoder :)"
HOMEPAGE="https://code.videolan.org/videolan/dav1d"

LICENSE="BSD-2"
SLOT="0/1"
IUSE="+8bit +10bit +asm"

ASM_DEPEND=">=dev-lang/nasm-2.13"
RDEPEND=""
DEPEND="${RDEPEND}
	asm? (
		abi_x86_32? ( ${ASM_DEPEND} )
		abi_x86_64? ( ${ASM_DEPEND} )
	)"

DOCS=( README.md doc/PATENTS )

multilib_src_configure() {
	local -a bits=()
	use 8bit  && bits+=( 8 )
	use 10bit && bits+=( 16 )

	if [[ ${MULTILIB_ABI_FLAG} == abi_x86_x32 ]]; then
		build_asm=false
	else
		build_asm=$(usex asm true false)
	fi

	local emesonargs=(
		-D bitdepths=$(IFS=,; echo "${bits[*]}")
		-D build_asm=$build_asm
	)
	meson_src_configure
}

multilib_src_compile() {
	eninja
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
}
