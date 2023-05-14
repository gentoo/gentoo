# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.5
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for notifying the user of an event"

LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="dbus phonon qml speech X"

RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kwindowsystem-${PVCUT}*:5[X?]
	dbus? ( dev-libs/libdbusmenu-qt[qt5(+)] )
	!phonon? ( media-libs/libcanberra )
	phonon? ( >=media-libs/phonon-4.11.0 )
	qml? ( >=dev-qt/qtdeclarative-${QTMIN}:5 )
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
BDEPEND=">=dev-qt/linguist-tools-${QTMIN}:5"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package dbus dbusmenu-qt5)
		$(cmake_use_find_package !phonon Canberra)
		$(cmake_use_find_package qml Qt5Qml)
		$(cmake_use_find_package speech Qt5TextToSpeech)
		-DWITHOUT_X11=$(usex !X)
	)

	ecm_src_configure
}
