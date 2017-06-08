# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="KDE Telepathy workspace integration"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_kdeapps_dep ktp-common-internals)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwidgets)
	net-libs/telepathy-qt[qt5]
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kwidgetsaddons)
"
RDEPEND="${COMMON_DEPEND}
	$(add_kdeapps_dep signon-kwallet-extension)
"
