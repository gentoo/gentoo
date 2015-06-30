# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-plasma/kscreen/kscreen-5.3.2.ebuild,v 1.1 2015/06/30 20:50:14 johu Exp $

EAPI=5

KDE_PUNT_BOGUS_DEPS="true"
inherit kde5

DESCRIPTION="KDE screen management"
HOMEPAGE="https://projects.kde.org/projects/extragear/base/kscreen"

KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_plasma_dep libkscreen)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	$(add_plasma_dep kde-cli-tools)
	dev-qt/qtgraphicaleffects:5
	!kde-misc/kscreen
"
