# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MOD_DESC="a terrorist vs. strike force mod"
MOD_NAME="Strike Force"
MOD_DIR="StrikeForce"

inherit games games-mods

HOMEPAGE="http://www.strikeforcegame.com/"
SRC_URI="StrikeForce-CE-V${PV}.zip"

LICENSE="freedist"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"
RESTRICT="fetch"

pkg_nofetch() {
	elog "Please download ${SRC_URI} from:"
	elog "${HOMEPAGE}"
	elog "and move it to ${DISTDIR}"
}

src_prepare() {
	rm -f ${MOD_DIR}/*.exe
}
