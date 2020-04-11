# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Framework for notifying the user of an event"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="dbus nls phonon speech X"

BDEPEND="
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
RDEPEND="
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kwindowsystem-${PVCUT}*:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	dbus? ( dev-libs/libdbusmenu-qt[qt5(+)] )
	!phonon? ( media-libs/libcanberra )
	phonon? ( media-libs/phonon[qt5(+)] )
	speech? ( >=dev-qt/qtspeech-${QTMIN}:5 )
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
		x11-libs/libXtst
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package dbus dbusmenu-qt5)
		$(cmake_use_find_package !phonon Canberra)
		$(cmake_use_find_package speech Qt5TextToSpeech)
		$(cmake_use_find_package X X11)
	)

	ecm_src_configure
}
