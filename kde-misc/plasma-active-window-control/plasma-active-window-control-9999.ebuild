# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Plasma 5 applet for controlling currently active window"
HOMEPAGE="https://store.kde.org/p/998910/"

LICENSE="GPL-2"
KEYWORDS=""
IUSE=""

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep plasma X)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtx11extras)
	$(add_qt_dep qtwidgets)
"
DEPEND="${RDEPEND}"
