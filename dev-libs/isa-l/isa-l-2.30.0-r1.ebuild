# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Intelligent Storage Acceleration Library"
HOMEPAGE="https://github.com/intel/isa-l"
SRC_URI="https://github.com/intel/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv -x86"
IUSE="cpu_flags_x86_avx512f"

# AVX512 support in yasm is still work in progress
BDEPEND="
	amd64? (
		cpu_flags_x86_avx512f? ( >=dev-lang/nasm-2.13 )
		!cpu_flags_x86_avx512f? ( || (
			>=dev-lang/nasm-2.11.01
			>=dev-lang/yasm-1.2.0
		) )
	)
	x86? (
		cpu_flags_x86_avx512f? ( >=dev-lang/nasm-2.13 )
		!cpu_flags_x86_avx512f? ( || (
			>=dev-lang/nasm-2.11.01
			>=dev-lang/yasm-1.2.0
		) )
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.30.0_fix-shebang.patch
	"${FILESDIR}"/${PN}-2.30.0_makefile-no-D.patch
	"${FILESDIR}"/${PN}-2.30.0_makefile-x86.patch
)

src_prepare() {
	default

	# isa-l does not support arbitrary assemblers on amd64 and x86,
	# it must be either nasm or yasm.
	if use amd64 || use x86; then
		unset AS
	fi

	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
