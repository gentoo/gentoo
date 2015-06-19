# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-plasma/khotkeys/khotkeys-5.3.1.ebuild,v 1.1 2015/05/31 22:06:17 johu Exp $

EAPI=5

KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="KDE workspace hotkey module"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support X)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_plasma_dep plasma-workspace)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11
"
RDEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kded)
	$(add_plasma_dep kde-cli-tools)
	!kde-base/khotkeys
	!kde-base/systemsettings
"
DEPEND="${COMMON_DEPEND}
	x11-libs/libxcb
	x11-libs/libXtst
	x11-proto/xproto
"
