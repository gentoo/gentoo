# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-bfp/quake3-bfp-1.2-r1.ebuild,v 1.7 2009/10/10 17:22:45 nyhm Exp $

EAPI=2

MOD_DESC="take control of Ki-powered superheros and battle in a mostly aerial fight"
MOD_NAME="Bid For Power"
MOD_DIR="bfpq3"
MOD_ICON="bfp.ico"

inherit games games-mods

HOMEPAGE="http://www.planetquake.com/bidforpower/"
SRC_URI="mirror://quakeunity/modifications/bidforpower/bidforpower${PV/./-}.zip"

LICENSE="freedist"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"
