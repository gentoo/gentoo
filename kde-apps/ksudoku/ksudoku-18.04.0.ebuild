# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Logic-based symbol placement puzzle by KDE"
HOMEPAGE="
	https://www.kde.org/applications/games/ksudoku/
	https://games.kde.org/game.php?game=ksudoku
"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep libkdegames)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	opengl? (
		$(add_qt_dep qtopengl)
		virtual/glu
	)
"
RDEPEND="${DEPEND}
	!<kde-apps/kde4-l10n-17.07.80
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package opengl OpenGL)
	)

	kde5_src_configure
}
