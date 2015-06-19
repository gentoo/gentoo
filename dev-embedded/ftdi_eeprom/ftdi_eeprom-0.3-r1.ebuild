# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/ftdi_eeprom/ftdi_eeprom-0.3-r1.ebuild,v 1.7 2015/05/13 10:37:04 vapier Exp $

EAPI=4
inherit eutils

DESCRIPTION="Utility to program external EEPROM for FTDI USB chips"
HOMEPAGE="http://www.intra2net.com/en/developer/libftdi/"
SRC_URI="http://www.intra2net.com/en/developer/libftdi/download/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="<dev-embedded/libftdi-1
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
