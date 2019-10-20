# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
inherit kde5

DESCRIPTION="Plasma integration for controlling Thunderbolt devices"
HOMEPAGE="https://cgit.kde.org/plasma-thunderbolt.git"

LICENSE="|| ( GPL-2 GPL-3+ )"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep knotifications)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
"
RDEPEND="${DEPEND}
	sys-apps/bolt
"
