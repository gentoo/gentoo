# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit fdo-mime kde5

DESCRIPTION="Bluetooth stack for KDE"
HOMEPAGE="http://projects.kde.org/projects/extragear/base/bluedevil"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep bluez-qt)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kded)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep plasma)
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
DEPEND="${COMMON_DEPEND}
	x11-misc/shared-mime-info
"
RDEPEND="${COMMON_DEPEND}
	$(add_plasma_dep kde-cli-tools)
	!app-mobilephone/obexd
	!app-mobilephone/obex-data-server
	!net-wireless/bluedevil
	!net-wireless/kbluetooth
"

pkg_postinst() {
	kde5_pkg_postinst
	fdo-mime_mime_database_update
}

pkg_postrm() {
	kde5_pkg_postinst
	fdo-mime_mime_database_update
}
