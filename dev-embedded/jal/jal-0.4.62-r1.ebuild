# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A high-level language for Microchip PIC and Ubicom SX microcontrollers"
HOMEPAGE="https://jal.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/jal/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.62-fix-incompatible-integer-to-pointer-clang16.patch
)

src_prepare() {
	default
	eautoreconf
}
