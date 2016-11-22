# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KDE_SELINUX_MODULE="games"
inherit kde4-base

DESCRIPTION="Game of action and puzzle solving by KDE"
HOMEPAGE="
	https://www.kde.org/applications/games/kgoldrunner/
	https://games.kde.org/game.php?game=kgoldrunner
"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep libkdegames)
	media-libs/libsndfile
	media-libs/openal
"
RDEPEND="${DEPEND}"
