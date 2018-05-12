# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_QTHELP="false"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework for integrating Qt applications with KDE Plasma workspaces"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="appstream X"

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	appstream? (
		app-admin/packagekit-qt
		dev-libs/appstream[qt5]
	)
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libxcb
	)
"
DEPEND="${RDEPEND}"

# requires running kde environment
RESTRICT+=" test"

src_prepare() {
	punt_bogus_dep Qt5 DBus
	kde5_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package appstream AppStreamQt)
		$(cmake-utils_use_find_package appstream packagekitqt5)
		$(cmake-utils_use_find_package X XCB)
	)

	kde5_src_configure
}
