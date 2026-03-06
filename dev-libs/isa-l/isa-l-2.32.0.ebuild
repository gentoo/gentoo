# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools

DESCRIPTION="Intelligent Storage Acceleration Library"
HOMEPAGE="https://github.com/intel/isa-l"
SRC_URI="https://github.com/intel/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	amd64? ( || (
		>=dev-lang/nasm-2.11.01
		>=dev-lang/yasm-1.2.0
	) )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.31.0_no-fortify-source.patch
	"${FILESDIR}"/${PN}-2.31.0_user-ldflags.patch
)

src_prepare() {
	default

	# isa-l does not support arbitrary assemblers on amd64 and x86,
	# it must be either nasm or yasm.
	if use amd64; then
		unset AS
	fi

	# upstream is using D for their own purposes, sigh
	sed -i -e 's:${D}:${DIST_D}:' Makefile.am || die

	eautoreconf
}

src_compile() {
	unset ARCH
	default
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
