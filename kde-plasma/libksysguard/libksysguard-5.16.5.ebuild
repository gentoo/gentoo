# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Task management and system monitoring library"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="minimal webengine X"

RDEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	sys-libs/zlib
	webengine? ( $(add_qt_dep qtwebengine) )
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
		x11-libs/libXres
	)
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kiconthemes)
	!minimal? ( $(add_frameworks_dep plasma) )
	X? ( x11-base/xorg-proto )
"

PATCHES=( "${FILESDIR}/${PN}-5.16.0-no-detailed-mem-message.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package !minimal KF5Plasma)
		$(cmake-utils_use_find_package webengine Qt5WebEngineWidgets)
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}
