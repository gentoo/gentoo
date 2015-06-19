# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-threewave/quake3-threewave-1.7-r1.ebuild,v 1.5 2009/10/10 17:30:19 nyhm Exp $

EAPI=2

MOD_DESC="Threewave CTF"
MOD_NAME="Threewave CTF"
MOD_DIR="threewave"

inherit games games-mods

HOMEPAGE="http://www.threewave.com/"
SRC_URI="mirror://quakeunity/modifications/threewavectf/threewave_16_full.zip
	mirror://quakeunity/modifications/threewavectf/threewave_17_update.zip"

LICENSE="freedist"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"

src_unpack() {
	unpack threewave_{16_full,17_update}.zip
}
