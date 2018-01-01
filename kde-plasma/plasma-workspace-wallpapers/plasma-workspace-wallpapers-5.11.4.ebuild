# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_AUTODEPS="false"
KDE_DEBUG="false"
inherit kde5

DESCRIPTION="Additional wallpapers for the Plasma workspace"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep extra-cmake-modules)
	$(add_qt_dep qtcore)
"
RDEPEND="!<kde-apps/kde-wallpapers-15.08.3-r2"
