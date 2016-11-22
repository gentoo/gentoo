# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="false"
inherit kde5

DESCRIPTION="Framework providing KDE integration of QtWebKit"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwallet)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
"
DEPEND="${RDEPEND}
	$(add_qt_dep qtnetwork)
"
