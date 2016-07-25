# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="System settings utility"
KEYWORDS="amd64 ~arm x86"
IUSE="classic gtk"

DEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	classic? ( $(add_frameworks_dep khtml) )
"
RDEPEND="${DEPEND}
	gtk? ( $(add_plasma_dep kde-gtk-config) )
	!kde-base/systemsettings:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package classic KF5KHtml)
	)

	kde5_src_configure
}
