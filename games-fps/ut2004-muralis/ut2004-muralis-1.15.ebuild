# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MOD_DESC="third-person hand-to-hand single/multiplayer mod"
MOD_NAME="Muralis"
MOD_DIR="muralis"

inherit unpacker games games-mods

HOMEPAGE="http://www.moddb.com/mods/muralis"
SRC_URI="https://ut.rushbase.net/beyondunreal/mods/muralis-v${PV}-zip.zip"

LICENSE="freedist"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"

src_prepare() {
	mv -f Muralis ${MOD_DIR} || die
}
