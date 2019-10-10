# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
inherit kde5

DESCRIPTION="Client library to access and handling of KAlarm calendar data"
LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kcalendarcore)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kholidays)
	$(add_frameworks_dep ki18n)
	$(add_kdeapps_dep akonadi)
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

src_test() {
	LANG="C" kde5_src_test #bug 665626
}
