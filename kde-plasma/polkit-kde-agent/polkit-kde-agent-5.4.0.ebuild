# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="${PN}-1"
inherit kde5

DESCRIPTION="PolKit agent module for KDE"
HOMEPAGE="http://www.kde.org"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=sys-auth/polkit-qt-0.112.0[qt5]
"
RDEPEND="${DEPEND}
	!sys-auth/polkit-kde-agent:4[-minimal(-)]
	!sys-auth/polkit-kde-agent:5
"
