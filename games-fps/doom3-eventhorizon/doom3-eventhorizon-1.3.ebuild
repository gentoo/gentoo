# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MOD_DESC="single-player mission based on the Event Horizon film"
MOD_NAME="Event Horizon"
MOD_DIR="eventhorizon"

inherit games games-mods

HOMEPAGE="http://doom3.filefront.com/file/Event_Horizon_XV;91253"
SRC_URI="event_horizon_xv_${PV}.zip"

LICENSE="all-rights-reserved"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"
RESTRICT="fetch mirror"

pkg_nofetch() {
	einfo
	einfo "Please download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_prepare() {
	mv -f event_horizon* ${MOD_DIR} || die
}
