# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_TEST="false"
inherit kde5

DESCRIPTION="Framework providing KDE integration of QtWebKit"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwallet)
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	dev-qt/qtnetwork:5
"
