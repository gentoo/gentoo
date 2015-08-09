# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MOD_DESC="port of Action Quake 2 to Quake 3: Arena"
MOD_NAME="Reaction"
MOD_DIR="rq3"
MOD_ICON="reaction-4.ico"

inherit games games-mods

HOMEPAGE="http://www.rq3.com/"
SRC_URI="
	mirror://quakeunity/modifications/reactionquake3/ReactionQuake3-v3.1-Full.zip
	mirror://quakeunity/modifications/reactionquake3/ReactionQuake3-v3.2-Update.zip
	"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dedicated opengl"
