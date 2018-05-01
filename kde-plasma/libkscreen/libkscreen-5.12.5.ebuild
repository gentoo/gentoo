# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Plasma screen management library"
SLOT="5/7"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kwayland)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtx11extras)
	x11-libs/libxcb
"
RDEPEND="${DEPEND}
	!x11-libs/libkscreen:5
"

# requires running session
RESTRICT+=" test"
