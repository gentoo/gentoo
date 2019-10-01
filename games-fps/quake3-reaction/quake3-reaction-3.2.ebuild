# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MOD_DESC="port of Action Quake 2 to Quake 3: Arena"
MOD_NAME="Reaction"
MOD_DIR="rq3"
MOD_ICON="reaction-4.ico"

inherit games games-mods

HOMEPAGE="http://www.rq3.com/"
SRC_URI="
	https://www.mirrorservice.org/sites/quakeunity.com/modifications/reactionquake3/ReactionQuake3-v3.1-Full.zip
	https://www.mirrorservice.org/sites/quakeunity.com/modifications/reactionquake3/ReactionQuake3-v3.2-Update.zip
	"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"
