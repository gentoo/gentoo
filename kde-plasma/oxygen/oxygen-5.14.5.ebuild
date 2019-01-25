# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Oxygen visual style for the Plasma desktop"
HOMEPAGE="https://cgit.kde.org/oxygen.git"
KEYWORDS="amd64 ~arm ~x86"
IUSE="wayland"

COMMON_DEPEND="
	$(add_frameworks_dep frameworkintegration)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_plasma_dep kdecoration)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	x11-libs/libxcb
	wayland? ( $(add_frameworks_dep kwayland) )
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kservice)
"
RDEPEND="${COMMON_DEPEND}
	$(add_plasma_dep kde-cli-tools)
	!kde-plasma/kdebase-cursors:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package wayland KF5Wayland)
	)
	kde5_src_configure
}
