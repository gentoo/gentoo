# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KDE_SELINUX_MODULE="games"
inherit kde4-base

DESCRIPTION="KDE: Kolor Lines - a little game about balls and how to get rid of them"
HOMEPAGE="
	https://www.kde.org/applications/games/klines/
	https://games.kde.org/game.php?game=klines
"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="$(add_kdeapps_dep libkdegames)"
RDEPEND="${DEPEND}"
