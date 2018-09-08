# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="KDE Telepathy file transfer handler"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"

LICENSE="GPL-2+ LGPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_kdeapps_dep ktp-common-internals)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	net-libs/telepathy-qt[qt5(+)]
"
RDEPEND="${DEPEND}"
