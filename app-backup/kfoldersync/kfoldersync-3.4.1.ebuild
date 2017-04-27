# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_GCC_MINIMAL="5.1"
inherit kde5

DESCRIPTION="Folder synchronization and backup tool based on KDE Frameworks"
HOMEPAGE="https://www.linux-apps.com/p/1127677/"
SRC_URI="https://dl.opendesktop.org/api/files/download/id/1485353737/${P}.tar.xz"

LICENSE="GPL-3"
KEYWORDS="amd64 ~arm x86"

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"
