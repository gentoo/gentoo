# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="KDE timer for making a fine cup of tea"
HOMEPAGE="https://www.kde.org/applications/games/kteatime"
KEYWORDS=" ~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kxmlgui)
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-dont-block-plasmashell.patch"
	"${FILESDIR}/${P}-drkonqi-integration.patch"
)
