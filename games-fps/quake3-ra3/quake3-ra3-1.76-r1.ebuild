# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MOD_DESC="a rocket dueling mod"
MOD_NAME="Rocket Arena 3"
MOD_DIR="arena"

inherit games games-mods

HOMEPAGE="https://www.moddb.com/mods/rocket-arena-3"
SRC_URI="https://www.mirrorservice.org/sites/quakeunity.com/modifications/rocketarena3/ra3${PV/.}.zip"

LICENSE="freedist"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"

QA_PREBUILT="${INS_DIR:1}/${MOD_DIR}/*so"
