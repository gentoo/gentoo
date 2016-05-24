# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_PUNT_BOGUS_DEPS="true"
inherit kde5

DESCRIPTION="KDE clone of the game squares"
HOMEPAGE="
	https://www.kde.org/applications/games/ksquares/
	https://games.kde.org/game.php?game=ksquares
"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep libkdegames)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-15.12.2-unused-deps.patch" )
