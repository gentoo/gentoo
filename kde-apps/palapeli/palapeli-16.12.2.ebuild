# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE jigsaw puzzle game"
HOMEPAGE="https://www.kde.org/applications/games/palapeli/"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug"

DEPEND="$(add_kdeapps_dep libkdegames)"
RDEPEND="${DEPEND}"
