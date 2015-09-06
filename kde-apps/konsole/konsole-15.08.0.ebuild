# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_BLOCK_SLOT4="false"
KDE_HANDBOOK="true"
KDE_TEST="true"
KDE_PUNT_BOGUS_DEPS="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KDE's terminal emulator"
HOMEPAGE="https://www.kde.org/applications/system/konsole https://konsole.kde.org"

KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND="
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kinit)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kpty)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	X? ( x11-libs/libX11 )
"
RDEPEND="${DEPEND}
	!kde-apps/konsole:4[-minimal(-),handbook]
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}
