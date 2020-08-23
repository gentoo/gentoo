# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit eutils

DESCRIPTION="Utility to program external EEPROM for FTDI USB chips"
HOMEPAGE="https://www.intra2net.com/en/developer/libftdi/"
SRC_URI="https://www.intra2net.com/en/developer/libftdi/download/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-embedded/libftdi:0
	dev-libs/confuse"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-newer-chips.patch #376117
	epatch "${FILESDIR}"/${PN}-0.3-chip-type.patch #390805
}

src_install() {
	default
	dodoc src/example.conf
}
