# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-ra3/quake3-ra3-1.76-r1.ebuild,v 1.5 2013/01/24 06:55:38 tupone Exp $

EAPI=2

MOD_DESC="a rocket dueling mod"
MOD_NAME="Rocket Arena 3"
MOD_DIR="arena"

inherit games games-mods

HOMEPAGE="http://www.planetquake.com/servers/arena/"
SRC_URI="mirror://quakeunity/modifications/rocketarena3/ra3${PV/.}.zip"

LICENSE="freedist"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"

QA_PREBUILT="${INS_DIR:1}/${MOD_DIR}/*so"
