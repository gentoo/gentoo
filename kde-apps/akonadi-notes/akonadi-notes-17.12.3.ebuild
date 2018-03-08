# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="true"
inherit kde5

DESCRIPTION="Library for akonadi notes integration"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2+"
IUSE=""

# some akonadi tests time out, that probably needs more work as it's ~700 tests
RESTRICT+=" test"

COMMON_DEPEND="
	$(add_frameworks_dep ki18n)
	$(add_kdeapps_dep kmime)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtxml)
"
DEPEND="${COMMON_DEPEND}
	$(add_kdeapps_dep akonadi)
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim-l10n
"
