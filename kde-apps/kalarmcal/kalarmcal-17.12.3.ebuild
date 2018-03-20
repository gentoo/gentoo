# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Client library to access and handling of KAlarm calendar data"
LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kholidays)
	$(add_frameworks_dep ki18n)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kidentitymanagement)
	$(add_qt_dep qtgui)
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
"
