# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="false"
inherit kde5

DESCRIPTION="Framework for notifying the user of an event"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="dbus nls phonon speech X"

BDEPEND="
	nls? ( $(add_qt_dep linguist-tools) )
"
RDEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dbus? ( dev-libs/libdbusmenu-qt[qt5(+)] )
	!phonon? ( media-libs/libcanberra )
	phonon? ( media-libs/phonon[qt5(+)] )
	speech? ( $(add_qt_dep qtspeech) )
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
		x11-libs/libXtst
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package dbus dbusmenu-qt5)
		$(cmake-utils_use_find_package !phonon Canberra)
		$(cmake-utils_use_find_package speech Qt5TextToSpeech)
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}
