# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MOD_DESC="third-person hand-to-hand single/multiplayer mod"
MOD_NAME="Muralis"
MOD_DIR="muralis"

inherit unpacker games games-mods

HOMEPAGE="http://www.ascensiongames.com/"
SRC_URI="muralis-v${PV}-zip.zip"

LICENSE="freedist"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"
RESTRICT="fetch"

pkg_nofetch() {
	elog "Please download ${SRC_URI} from:"
	elog "http://www.atomicgamer.com/file.php?id=42750"
	elog "and move it to ${DISTDIR}"
}

src_prepare() {
	mv -f Muralis ${MOD_DIR} || die
}
