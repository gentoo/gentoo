# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/knotifications/knotifications-5.10.0.ebuild,v 1.1 2015/05/09 10:36:05 mrueg Exp $

EAPI=5

KDE_TEST="false"
inherit kde5

DESCRIPTION="Framework for notifying the user of an event, including feedback and persistant events"
LICENSE="LGPL-2.1+"
KEYWORDS=" ~amd64 ~x86"
IUSE="dbus X nls"

RDEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwindowsystem)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-libs/phonon[qt5]
	dbus? ( dev-libs/libdbusmenu-qt[qt5] )
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
		$(cmake-utils_use_find_package X X11)
		$(cmake-utils_use_find_package dbus DBusMenuQt5)
	)

	kde5_src_configure
}
