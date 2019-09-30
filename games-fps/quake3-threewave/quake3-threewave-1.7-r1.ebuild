# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MOD_DESC="Threewave CTF"
MOD_NAME="Threewave CTF"
MOD_DIR="threewave"

inherit games games-mods

HOMEPAGE="http://www.threewave.com/"
SRC_URI="https://www.mirrorservice.org/sites/quakeunity.com/modifications/threewavectf/threewave_16_full.zip
	https://www.mirrorservice.org/sites/quakeunity.com/modifications/threewavectf/threewave_17_update.zip"

LICENSE="freedist"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"

src_unpack() {
	unpack threewave_{16_full,17_update}.zip
}
