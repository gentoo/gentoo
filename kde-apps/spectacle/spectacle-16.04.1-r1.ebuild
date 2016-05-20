# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Screenshot capture utility"
KEYWORDS="~amd64 ~x86"
IUSE="kipi share"

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_plasma_dep libkscreen '' '' '5=')
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	x11-libs/libxcb
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-image
	kipi? ( $(add_kdeapps_dep libkipi '' '' '5=') )
	share? ( dev-libs/purpose:5 )
"
RDEPEND="${DEPEND}
	!kde-apps/ksnapshot
"

PATCHES=( "${FILESDIR}/${P}-hotkeys.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package kipi KF5Kipi)
		$(cmake-utils_use_find_package share KDEExperimentalPurpose)
	)
	kde5_src_configure
}
