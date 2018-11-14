# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Utility for viewing/manipulating the MAC address of network interfaces"
OUI_DATE="20091029" # Generated with tools/IEEE_OUI.py in the source
OUI_FILE="OUI.list-${OUI_DATE}"
HOMEPAGE="https://github.com/alobbs/macchanger"
SRC_URI="https://github.com/alobbs/macchanger/releases/download/${PV}/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 arm ppc sparc x86"
SLOT="0"

src_configure() {
	# Shared data is installed below /lib, see Bug #57046
	econf \
		--bindir=/sbin \
		--datadir=/lib
}

src_install() {
	default

	dodoc AUTHORS ChangeLog NEWS README

	dodir /usr/bin
	dosym /sbin/macchanger /usr/bin/macchanger
	dosym /lib/macchanger /usr/share/macchanger
}
