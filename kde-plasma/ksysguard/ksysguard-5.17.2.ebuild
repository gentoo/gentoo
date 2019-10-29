# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Network-enabled task manager and system monitor"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="caps lm-sensors"

DEPEND="
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
	$(add_plasma_dep libksysguard '-minimal(-)')
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	caps? (
		net-libs/libpcap
		sys-libs/libcap
	)
	lm-sensors? ( sys-apps/lm-sensors:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package caps Libcap)
		$(cmake-utils_use_find_package lm-sensors Sensors)
	)

	kde5_src_configure
}
