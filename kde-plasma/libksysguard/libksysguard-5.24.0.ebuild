# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_TEST="true"
KFMIN=5.90.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Task management and system monitoring library"

LICENSE="LGPL-2+"
SLOT="5/9"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="webengine X"

COMMON_DEPEND="
	dev-libs/libnl:3
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/kpackage-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	net-libs/libpcap
	sys-apps/lm-sensors:=
	sys-libs/libcap
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
DEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	X? ( x11-base/xorg-proto )
"
RDEPEND="${COMMON_DEPEND}
	!<kde-plasma/ksysguard-5.21.90:5
	!<kde-plasma/plasma-workspace-5.18.80:5
"

PATCHES=( "${FILESDIR}/${PN}-5.22.80-no-detailed-mem-message.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package webengine Qt5WebChannel)
		$(cmake_use_find_package webengine Qt5WebEngineWidgets)
		$(cmake_use_find_package X X11)
	)

	ecm_src_configure
}

src_test() {
	LC_NUMERIC="C" ecm_src_test # bug 695514
}
