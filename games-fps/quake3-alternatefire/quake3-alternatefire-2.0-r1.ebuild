# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-alternatefire/quake3-alternatefire-2.0-r1.ebuild,v 1.6 2009/10/10 17:21:30 nyhm Exp $

EAPI=2

MOD_DESC="adds unique new secondary attacks to weapons"
MOD_NAME="Alternate Fire"
MOD_DIR="alternatefire"

inherit games games-mods

HOMEPAGE="http://www.planetquake.com/alternatefire/"
SRC_URI="mirror://quakeunity/modifications/alternatefire/alternatefire-${PV}.zip"

LICENSE="freedist"

KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"
