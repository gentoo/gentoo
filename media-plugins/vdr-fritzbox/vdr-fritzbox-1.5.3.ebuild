# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Inform about incoming phone-calls and use the fritz!box phonebook"
HOMEPAGE="https://github.com/jowi24/vdr-fritz"
SRC_URI="https://github.com/jowi24/vdr-fritz/releases/download/1.5.3/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-1.7.34
		dev-libs/libgcrypt:0
		dev-libs/boost[threads]"
RDEPEND="${DEPEND}"

pkg_postinst() {
	echo
	elog "It is recommend to update your firmware release to the latest."
	echo
	elog "The integrated call monitor (available in Fritz!Box official"
	elog "firmware releases >= *.04.29) has to be enabled in order to"
	elog "have the vdr-fritzbox plugin display anything on your tv. To"
	elog "enable it call #96*5* from your telephone. If that doesn't"
	elog "work for you, read the documentation for further instructions."
	echo
}
