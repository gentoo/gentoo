# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MOD_DESC="Doom 1 conversion for Doom 3"
MOD_NAME="Classic Doom"
MOD_DIR="cdoom"
MOD_ICON="cdoom.ico"

inherit games games-mods

HOMEPAGE="http://cdoom.d3files.com/"
SRC_URI="classic_doom_3_${PV//.}.zip"

LICENSE="GameFront"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"
RESTRICT="fetch bindist"

pkg_nofetch() {
	elog "Please download ${SRC_URI} from:"
	elog "http://www.filefront.com/8748743"
	elog "and move it to ${DISTDIR}"
}

src_prepare() {
	cd ${MOD_DIR} || die
	rm -f *.{bat,url} cdoom_{dll,mac}.pk4
}
