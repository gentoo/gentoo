# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GAME="enemy-territory"
MOD_DESC="Bots for Ennemy Territory"
MOD_NAME="Omnibot"
MOD_DIR="omnibot"

inherit games games-mods

HOMEPAGE="http://www.omni-bot.com/"
MY_PV="${PV//./_}"
SRC_URI="http://omni-bot.invisionzone.com/index.php?/files/getdownload/208-omni-bot-enemy-territory -> omni-bot_${MY_PV}_ET_linux.zip
	http://omni-bot.invisionzone.com/index.php?/files/getdownload/207-omni-bot-enemy-territory -> omni-bot_${MY_PV}_ET_waypoint_mod.zip"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror strip"
