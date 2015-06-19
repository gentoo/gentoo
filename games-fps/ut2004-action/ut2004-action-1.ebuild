# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2004-action/ut2004-action-1.ebuild,v 1.3 2009/10/08 23:09:11 nyhm Exp $

EAPI=2

MOD_DESC="Action movie mod"
MOD_NAME="Action"
MOD_DIR="action"
MOD_ICON="aut.ico"

inherit games games-mods

HOMEPAGE="http://www.ateamproductions.net/"
SRC_URI="aut-r1-msuc.zip"

LICENSE="freedist"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"
RESTRICT="fetch"

pkg_nofetch() {
	elog "Please download ${SRC_URI} from:"
	elog "http://www.atomicgamer.com/file.php?id=45011"
	elog "and move it to ${DISTDIR}"
}

src_unpack() {
	mkdir ${MOD_DIR}
	cd ${MOD_DIR}
	unpack ${A}
}
