# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2004-hamsterbash/ut2004-hamsterbash-1.ebuild,v 1.4 2013/03/29 16:21:26 hasufell Exp $

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
