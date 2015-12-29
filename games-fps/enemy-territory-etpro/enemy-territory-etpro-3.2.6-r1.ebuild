# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GAME="enemy-territory"
MOD_DESC="Minor additions to Enemy Territory to make it more fun"
MOD_NAME="ETPro"
MOD_DIR="etpro"

inherit games games-mods

HOMEPAGE="http://etpro.anime.net/"
SRC_URI="http://bani.anime.net/etpro/etpro-${PV//./_}.zip
	http://www.enemyterritory.sk/files/etpro-${PV//./_}.zip"

LICENSE="all-rights-reserved"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"

QA_PREBUILT="${INS_DIR:1}/${MOD_DIR}/*so"
