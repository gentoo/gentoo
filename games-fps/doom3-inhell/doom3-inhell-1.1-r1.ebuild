# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MOD_DESC="Ultimate Doom-inspired levels for Doom 3"
MOD_NAME="In Hell"
MOD_DIR="inhell"

inherit games games-mods

HOMEPAGE="http://www.doomerland.de.vu/"
SRC_URI="in_hell_v${PV/.}.zip"

LICENSE="GameFront"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"
RESTRICT="fetch bindist"

pkg_nofetch() {
	elog "Please download ${SRC_URI} from:"
	elog "http://www.filefront.com/4631315"
	elog "and move it to ${DISTDIR}"
}

src_prepare() {
	mv -f In_Hell ${MOD_DIR} || die
}
