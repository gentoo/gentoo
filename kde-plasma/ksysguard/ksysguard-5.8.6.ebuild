# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Network-enabled task manager and system monitor"
LICENSE="GPL-2+"
KEYWORDS="amd64 ~arm ~x86"
IUSE="lm_sensors"

DEPEND="
	$(add_plasma_dep libksysguard)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kinit)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	lm_sensors? ( sys-apps/lm_sensors )
"
RDEPEND="${DEPEND}
	!kde-plasma/ksysguard:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package lm_sensors Sensors)
	)

	kde5_src_configure
}
