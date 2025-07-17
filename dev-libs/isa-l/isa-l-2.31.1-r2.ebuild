# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Intelligent Storage Acceleration Library"
HOMEPAGE="https://github.com/intel/isa-l"
SRC_URI="https://github.com/intel/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	amd64? ( || (
		>=dev-lang/nasm-2.11.01
		>=dev-lang/yasm-1.2.0
	) )
	x86? ( || (
		>=dev-lang/nasm-2.11.01
		>=dev-lang/yasm-1.2.0
	) )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.31.0_makefile-no-D.patch
	"${FILESDIR}"/${PN}-2.31.0_makefile-x86.patch
	"${FILESDIR}"/${PN}-2.31.0_no-fortify-source.patch
	"${FILESDIR}"/${PN}-2.31.0_user-ldflags.patch
	# https://github.com/intel/isa-l/commit/633add1b569fe927bace3960d7c84ed9c1b38bb9
	# https://github.com/intel/isa-l/commit/e3c2d243a11ae31a19f090206cbe90c84b12ceb1
	"${FILESDIR}"/${P}-big-endian.patch
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

src_compile() {
	unset ARCH
	default
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
