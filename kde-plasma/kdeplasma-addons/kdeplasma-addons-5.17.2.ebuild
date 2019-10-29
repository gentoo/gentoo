# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Extra Plasma applets and engines"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="share webengine"

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kholidays)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep kross)
	$(add_frameworks_dep krunner)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kunitconversion)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	$(add_frameworks_dep sonnet)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	share? ( $(add_frameworks_dep purpose) )
	webengine? ( $(add_qt_dep qtwebengine) )
"
RDEPEND="${DEPEND}
	$(add_plasma_dep plasma-workspace)
	$(add_qt_dep qtquickcontrols)
	$(add_qt_dep qtquickcontrols2)
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package share KF5Purpose)
		$(cmake-utils_use_find_package webengine Qt5WebEngine)
	)

	kde5_src_configure
}
