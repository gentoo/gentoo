# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KDE_SELINUX_MODULE="games"
inherit kde4-base

DESCRIPTION="Galactic Strategy KDE Game"
HOMEPAGE="
	https://www.kde.org/applications/games/konquest/
	https://games.kde.org/game.php?game=konquest
"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep libkdegames)
"
RDEPEND="${DEPEND}"
