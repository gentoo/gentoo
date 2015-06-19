# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/ftdi_eeprom/ftdi_eeprom-1.0.ebuild,v 1.1 2015/05/13 10:42:51 vapier Exp $

EAPI=4

DESCRIPTION="Utility to program external EEPROM for FTDI USB chips"
HOMEPAGE="http://www.intra2net.com/en/developer/libftdi/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-embedded/libftdi[tools]"

pkg_setup() {
	elog "This tool has moved to libftdi itself (via USE=tools)."
	elog "Please install that package and remove this one."
}
