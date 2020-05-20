# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
KFMIN=5.66.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Task management and system monitoring library"
LICENSE="LGPL-2+"
SLOT="5/8"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="minimal webengine X"

RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	sys-libs/zlib
	webengine? (
		>=dev-qt/qtwebchannel-${QTMIN}:5
		>=dev-qt/qtwebengine-${QTMIN}:5
	)
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
		x11-libs/libXres
	)
"
DEPEND="${RDEPEND}
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	!minimal? ( >=kde-frameworks/plasma-${KFMIN}:5 )
	X? ( x11-base/xorg-proto )
"

PATCHES=( "${FILESDIR}/${PN}-5.16.0-no-detailed-mem-message.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package !minimal KF5Plasma)
		$(cmake_use_find_package webengine Qt5WebChannel)
		$(cmake_use_find_package webengine Qt5WebEngineWidgets)
		$(cmake_use_find_package X X11)
	)

	ecm_src_configure
}

src_test() {
	LC_NUMERIC="C" ecm_src_test # bug 695514
}
