# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

QT_MINIMAL="5.5.1"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework for integrating Qt applications with KDE workspaces"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="X"

RDEPEND="
	$(add_plasma_dep oxygen-fonts)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui '' '' '5=')
	$(add_qt_dep qtwidgets)
	media-fonts/noto
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libxcb
		x11-libs/libXcursor
	)
"
DEPEND="${RDEPEND}"

# requires running kde environment
RESTRICT="test"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package X XCB)
	)

	kde5_src_configure
}
