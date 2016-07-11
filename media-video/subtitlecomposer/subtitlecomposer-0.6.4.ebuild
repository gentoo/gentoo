# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_MIN_VERSION="3.3"
KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="Text-based subtitles editor"
HOMEPAGE="https://github.com/maxrd2/subtitlecomposer"
SRC_URI="https://github.com/maxrd2/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="mpv unicode xine"

CDEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kross)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-libs/glib:2
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/phonon[qt5]
	mpv? ( media-video/mpv )
	unicode? ( dev-libs/icu:= )
	xine? (
		media-libs/xine-lib
		x11-libs/libxcb
	)
"
RDEPEND="${CDPEEND}
	!media-video/subtitlecomposer:4
"
DEPEND="${CDEPEND}
	sys-devel/gettext
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package mpv MPV)
		$(cmake-utils_use_find_package unicode ICU)
		$(cmake-utils_use_find_package xine Xine)
		$(cmake-utils_use_find_package xine XCB)
	)

	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst

	echo
	elog "Some example scripts provided by ${PV} require dev-lang/ruby"
	elog "or dev-lang/python to be installed."
	echo
}
