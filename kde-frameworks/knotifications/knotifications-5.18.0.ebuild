# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_TEST="false"
inherit kde5

DESCRIPTION="Framework for notifying the user of an event"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="dbus nls speech X"

RDEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kwindowsystem)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-libs/phonon[qt5]
	dbus? ( dev-libs/libdbusmenu-qt[qt5] )
	speech? ( dev-qt/qtspeech:5 )
	X? (
		dev-qt/qtx11extras:5
		x11-libs/libX11
		x11-libs/libXtst
	)
"
DEPEND="${RDEPEND}
	nls? ( dev-qt/linguist-tools:5 )
	X? ( x11-proto/xproto )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package dbus DBusMenuQt5)
		$(cmake-utils_use_find_package speech Qt5TextToSpeech)
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}
