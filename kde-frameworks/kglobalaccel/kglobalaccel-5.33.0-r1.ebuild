# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework to handle global shortcuts"
KEYWORDS="~amd64 ~arm ~x86"
LICENSE="LGPL-2+"
IUSE="nls"

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kwindowsystem X)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
"
DEPEND="${RDEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
"

PATCHES=( "${FILESDIR}/${P}-deps.patch" )
