# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A high-level language for Microchip PIC and Ubicom SX microcontrollers"
HOMEPAGE="https://jal.sourceforge.net/"
SRC_URI="mirror://sourceforge/jal/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.62-fix-incompatible-integer-to-pointer-clang16.patch
)

src_prepare() {
	default
	eautoreconf
}
