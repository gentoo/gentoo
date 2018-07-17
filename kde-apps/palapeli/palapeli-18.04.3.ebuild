# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
inherit kde5

DESCRIPTION="Jigsaw puzzle game by KDE"
HOMEPAGE="https://www.kde.org/applications/games/palapeli/"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep libkdegames)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
"
DEPEND="${COMMON_DEPEND}
	$(add_qt_dep qtconcurrent)
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kde4-l10n
"
