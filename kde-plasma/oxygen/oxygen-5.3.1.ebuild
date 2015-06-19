# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-plasma/oxygen/oxygen-5.3.1.ebuild,v 1.1 2015/05/31 22:06:18 johu Exp $

EAPI=5

inherit kde5

DESCRIPTION="KDE window manager theme"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/oxygen"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	$(add_frameworks_dep frameworkintegration)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_plasma_dep kdecoration)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libxcb
	!kde-base/kdebase-cursors
	!kde-base/oxygen
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kservice)
"
