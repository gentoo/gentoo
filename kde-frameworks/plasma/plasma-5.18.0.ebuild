# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="${PN}-framework"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Plasma framework"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~x86"
IUSE="egl gles2 X"

COMMON_DEPEND="
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
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5[gles2=]
	dev-qt/qtquickcontrols:5
	dev-qt/qtscript:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	egl? ( media-libs/mesa[egl] )
	!gles2? ( virtual/opengl )
	X? (
		dev-qt/qtx11extras:5
		x11-libs/libX11
		x11-libs/libxcb
	)
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kdoctools)
	dev-qt/qtquick1:5
	X? ( x11-proto/xproto )
"
RDEPEND="${COMMON_DEPEND}
	!<kde-apps/kapptemplate-15.08.3-r1:5
	!<kde-plasma/kdeplasma-addons-5.4.3-r1
"

RESTRICT="test"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package egl EGL)
		$(cmake-utils_use_find_package !gles2 OpenGL)
		$(cmake-utils_use_find_package X X11)
		$(cmake-utils_use_find_package X XCB)
	)

	kde5_src_configure
}
