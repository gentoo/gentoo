# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE: Ksirk is a KDE port of the board game risk"
HOMEPAGE="
	https://www.kde.org/applications/games/ksirk/
	https://games.kde.org/game.php?game=ksirk
"
KEYWORDS=" amd64 x86"
IUSE="debug"

DEPEND="
	app-crypt/qca:2[qt4]
	$(add_kdeapps_dep libkdegames)
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
