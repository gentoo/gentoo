# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="true"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KDE window manager"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gles2 multimedia"

COMMON_DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep kinit)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem X)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	$(add_plasma_dep kdecoration)
	$(add_plasma_dep kscreenlocker)
	$(add_plasma_dep kwayland)
	>=dev-libs/libinput-0.10
	>=dev-libs/wayland-1.2
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5[gles2=,opengl(+)]
	dev-qt/qtscript:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libepoxy
	media-libs/mesa[egl,gbm,gles2?,wayland]
	virtual/libudev:=
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libdrm
	>=x11-libs/libxcb-1.10
	>=x11-libs/libxkbcommon-0.4.1
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
"
RDEPEND="${COMMON_DEPEND}
	$(add_plasma_dep kde-cli-tools)
	multimedia? (
		|| (
			dev-qt/qtmultimedia:5[gstreamer,qml]
			dev-qt/qtmultimedia:5[gstreamer010,qml]
		)
	)
	!kde-base/kwin:4
	!kde-base/systemsettings:4
"
DEPEND="${COMMON_DEPEND}
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	x11-proto/xproto
	test? (	x11-libs/xcb-util-wm )
"

src_prepare() {
	kde5_src_prepare
	use multimedia || epatch "${FILESDIR}/${PN}-gstreamer-optional.patch"
}
