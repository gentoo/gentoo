# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MOD_DESC="Star Wars mod"
MOD_NAME="Troopers"
MOD_DIR="Troopers"
MOD_ICON="Help/Troopers.ico"

inherit games games-mods

HOMEPAGE="http://www.ut2004troopers.com/"
SRC_URI="troopersversion${PV/.}zip.zip"

LICENSE="freedist"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"
RESTRICT="fetch"

pkg_nofetch() {
	elog "Please download ${SRC_URI} from:"
	elog "http://www.atomicgamer.com/file.php?id=65532"
	elog "and move it to ${DISTDIR}"
}

src_prepare() {
	rm -f ${MOD_DIR}/*.{bat,sh}
}
