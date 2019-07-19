# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
inherit kde5

DESCRIPTION="Library for akonadi notes integration"
KEYWORDS="~amd64 ~arm64 ~x86"
LICENSE="GPL-2+"
IUSE=""

DEPEND="
	$(add_frameworks_dep ki18n)
	$(add_kdeapps_dep kmime)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtxml)
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
"
