# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/enemy-territory-etpro/enemy-territory-etpro-3.2.6-r1.ebuild,v 1.6 2014/04/18 06:46:08 ulm Exp $

EAPI=2

GAME="enemy-territory"
MOD_DESC="a series of minor additions to Enemy Territory to make it more fun"
MOD_NAME="ETPro"
MOD_DIR="etpro"

inherit games games-mods

HOMEPAGE="http://bani.anime.net/etpro/"
SRC_URI="http://etpro.anime.net/etpro-${PV//./_}.zip"

LICENSE="all-rights-reserved"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"

QA_PREBUILT="${INS_DIR:1}/${MOD_DIR}/*so"
