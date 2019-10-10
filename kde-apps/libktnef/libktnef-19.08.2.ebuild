# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
KMNAME="ktnef"
inherit kde5

DESCRIPTION="Library for handling TNEF data"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcalendarcore)
	$(add_frameworks_dep kcontacts)
	$(add_frameworks_dep ki18n)
	$(add_kdeapps_dep kcalutils)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
"
