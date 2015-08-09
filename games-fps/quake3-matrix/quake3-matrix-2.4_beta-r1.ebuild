# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MOD_DESC="Matrix conversion mod"
MOD_NAME="Matrix"
MOD_DIR="matrix"

inherit games games-mods

HOMEPAGE="http://www.moddb.com/mods/matrix-quake-3"
SRC_URI="mirror://quakeunity/modifications/matrix24.zip"

LICENSE="freedist"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"

src_unpack() {
	mkdir ${MOD_DIR}
	cd ${MOD_DIR}
	unpack ${A}
}
