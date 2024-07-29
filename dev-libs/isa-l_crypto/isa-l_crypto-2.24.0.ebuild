# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Intelligent Storage Acceleration Library - cryptographic components"
HOMEPAGE="https://github.com/intel/isa-l_crypto"
SRC_URI="https://github.com/intel/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cpu_flags_x86_avx512f"

# AVX512 support in yasm is still work in progress
BDEPEND="amd64? (
	cpu_flags_x86_avx512f? ( >=dev-lang/nasm-2.13 )
	!cpu_flags_x86_avx512f? ( || (
		>=dev-lang/nasm-2.11.01
		>=dev-lang/yasm-1.2.0
	) )
)"

PATCHES=(
	"${FILESDIR}"/${PN}-2.24.0_fix-shebang.patch
	"${FILESDIR}"/${PN}-2.24.0_makefile-no-D.patch
)

src_prepare() {
	default

	# isa-l does not support arbitrary assemblers on amd64 (and presumably x86),
	# it must be either nasm or yasm.
	use amd64 && unset AS

	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
