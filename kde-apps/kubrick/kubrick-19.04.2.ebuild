# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Game based on the \"Rubik's Cube\" puzzle by KDE"
HOMEPAGE="https://kde.org/applications/games/kubrick/"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep libkdegames)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtopengl)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	virtual/glu
	virtual/opengl
"
RDEPEND="${DEPEND}
	!<kde-apps/kde4-l10n-17.07.80
"
