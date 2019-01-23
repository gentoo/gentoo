# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Frontend for Cachegrind by KDE"
HOMEPAGE="https://www.kde.org/applications/development/kcachegrind
https://kcachegrind.github.io/html/Home.html"
KEYWORDS="amd64 ~x86"
IUSE="nls"

COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
DEPEND="${COMMON_DEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
"
RDEPEND="${COMMON_DEPEND}
	media-gfx/graphviz
	!<kde-apps/kde4-l10n-17.03.90:4
"
