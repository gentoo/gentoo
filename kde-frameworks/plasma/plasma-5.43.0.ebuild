# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="${PN}-framework"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Plasma framework"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="gles2 wayland X"

# drop qtdeclarative subslot operator when QT_MINIMAL >= 5.9.0
RDEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kirigami)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative '' '' '5=')
	$(add_qt_dep qtgui 'gles2=')
	$(add_qt_dep qtquickcontrols)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	!gles2? ( virtual/opengl )
	wayland? (
		$(add_frameworks_dep kwayland)
		media-libs/mesa[egl]
	)
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
		x11-libs/libxcb
	)
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kdoctools)
	X? ( x11-proto/xproto )
"

RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package !gles2 OpenGL)
		$(cmake-utils_use_find_package wayland EGL)
		$(cmake-utils_use_find_package wayland KF5Wayland)
		$(cmake-utils_use_find_package X X11)
		$(cmake-utils_use_find_package X XCB)
	)

	kde5_src_configure
}
