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

#DEPEND=""
#RDEPEND=""
# TODO: yasm version to support avx512?
BDEPEND="amd64? ( >=dev-lang/nasm-2.15 )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.30.0_makefile-no-D.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
