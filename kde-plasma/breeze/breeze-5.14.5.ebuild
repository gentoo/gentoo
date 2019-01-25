# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Breeze visual style for the Plasma desktop"
HOMEPAGE="https://cgit.kde.org/breeze.git"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="wayland X"

RDEPEND="
	$(add_frameworks_dep frameworkintegration)
	$(add_frameworks_dep kcmutils)
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
	sci-libs/fftw:3.0=
	wayland? ( $(add_frameworks_dep kwayland) )
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libxcb
	)
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kpackage)
"
PDEPEND="
	$(add_frameworks_dep breeze-icons)
	$(add_plasma_dep kde-cli-tools)
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package wayland KF5Wayland)
		$(cmake-utils_use_find_package X XCB)
	)
	kde5_src_configure
}
