# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="true"
inherit kde5

DESCRIPTION="Client library to access and handling of KAlarm calendar data"
LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kholidays)
	$(add_frameworks_dep ki18n)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kcalutils)
	$(add_kdeapps_dep kidentitymanagement)
	$(add_qt_dep qtgui)
"
DEPEND="${COMMON_DEPEND}
	test? ( $(add_qt_dep qtdbus) )
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim-l10n
	!<kde-apps/kdepim-runtime-18.03.80
"

RESTRICT+=" test" # broken within Plasma session, bug #665626
