# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="Port of the board game risk"
HOMEPAGE="
	https://www.kde.org/applications/games/ksirk/
	https://games.kde.org/game.php?game=ksirk
"
KEYWORDS="amd64 ~arm x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep libkdegames)
	app-crypt/qca:2[qt4]
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
