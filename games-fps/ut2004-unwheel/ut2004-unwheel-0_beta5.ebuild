# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MOD_DESC="multiplayer driving mod focusing on fun driving"
MOD_NAME="UnWheel"
MOD_DIR="unwheel"

inherit games games-mods

HOMEPAGE="http://unwheel.beyondunreal.com/"
SRC_URI="unwheel_r5.zip
	UnWheel-R5_BonusPack-Volume_1.zip"

LICENSE="GameFront"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"
RESTRICT="fetch bindist"

pkg_nofetch() {
	elog "Please download the following files:"
	elog "http://www.filefront.com/5110896"
	elog "http://www.filefront.com/13792114"
	elog "and move them to ${DISTDIR}"
}

src_unpack() {
	mkdir ${MOD_DIR}
	cd ${MOD_DIR}
	unpack ${A}
}
