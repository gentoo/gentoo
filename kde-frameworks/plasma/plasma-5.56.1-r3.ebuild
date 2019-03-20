# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="${PN}-framework"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Plasma framework"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${P}-broken-svgz.tar.xz"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="gles2 wayland X"

BDEPEND="
	$(add_frameworks_dep kdoctools)
"
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
	$(add_qt_dep qtdeclarative)
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
	X? ( x11-base/xorg-proto )
"

RESTRICT+=" test"

src_prepare() {
	kde5_src_prepare
	# QtSvg 5.12.2 uncovered a bug: https://phabricator.kde.org/D19821, https://bugs.kde.org/show_bug.cgi?id=405548
	cp -v "${WORKDIR}"/{${KMNAME},${KMNAME}-${PV}}/src/desktoptheme/breeze/dialogs/background.svgz || die
	cp -v "${WORKDIR}"/{${KMNAME},${KMNAME}-${PV}}/src/desktoptheme/breeze/translucent/dialogs/background.svgz || die
	cp -v "${WORKDIR}"/{${KMNAME},${KMNAME}-${PV}}/src/desktoptheme/breeze/translucent/widgets/tooltip.svgz || die
	cp -v "${WORKDIR}"/{${KMNAME},${KMNAME}-${PV}}/src/desktoptheme/breeze/widgets/tooltip.svgz || die
}

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
