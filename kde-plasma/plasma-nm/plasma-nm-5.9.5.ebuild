# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="KDE Plasma applet for NetworkManager"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="modemmanager openconnect teamd"

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep networkmanager-qt 'teamd=')
	$(add_frameworks_dep plasma)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	>=app-crypt/qca-2.1.1:2[qt5]
	>=net-misc/networkmanager-0.9.10.0[teamd=]
	modemmanager? (
		$(add_frameworks_dep modemmanager-qt)
		$(add_qt_dep qtxml)
		net-misc/mobile-broadband-provider-info
	)
	openconnect? (
		$(add_qt_dep qtxml)
		net-misc/networkmanager-openconnect
		net-vpn/openconnect:=
	)
"
RDEPEND="${DEPEND}
	$(add_plasma_dep plasma-workspace)
	!kde-plasma/plasma-nm:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package modemmanager ModemManager)
		$(cmake-utils_use_find_package modemmanager KF5ModemManagerQt)
		$(cmake-utils_use_find_package openconnect OpenConnect)
	)

	kde5_src_configure
}
