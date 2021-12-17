# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Intelligent Storage Acceleration Library"
HOMEPAGE="https://github.com/intel/isa-l"
SRC_URI="https://github.com/intel/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="amd64? (
	|| (
		>=dev-lang/nasm-2.13
		>=dev-lang/yasm-1.2.0
	)
)"

PATCHES=(
	"${FILESDIR}"/${PN}-2.30.0_makefile-no-D.patch
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
