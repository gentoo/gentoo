# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE Go game"
HOMEPAGE="https://www.kde.org/applications/games/kigo/"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="$(add_kdeapps_dep libkdegames)"
RDEPEND="
	${DEPEND}
	games-board/gnugo
"
