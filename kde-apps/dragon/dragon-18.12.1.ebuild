# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="A simple video player"
HOMEPAGE="https://www.kde.org/applications/multimedia/dragonplayer"

LICENSE="GPL-2+ || ( GPL-2 GPL-3 ) handbook? ( FDL-1.2 )"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	media-libs/phonon[qt5(+)]
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"
