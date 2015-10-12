# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MOD_DESC="Cute and violent hamster cage rampage mod"
MOD_NAME="Hamster Bash"
MOD_DIR="hamsterbash"

inherit unpacker games games-mods

HOMEPAGE="http://www.eigensoft.com/hamsterbash.htm"
SRC_URI="http://server088.eigensoft.com/HamsterBashFinal.zip"

LICENSE="freedist"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"

src_prepare() {
	mv -f HamsterBash ${MOD_DIR} || die
	rm -rf System
}
