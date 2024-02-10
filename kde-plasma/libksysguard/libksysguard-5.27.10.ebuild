# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_TEST="true"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm plasma.kde.org

DESCRIPTION="Task management and system monitoring library"

LICENSE="LGPL-2+"
SLOT="5/9"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="webengine"

# kde-frameworks/kwindowsystem[X]: Unconditional use of KX11Extras
RDEPEND="
	dev-libs/libnl:3
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5[qml]
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/kpackage-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5[X]
	>=kde-frameworks/solid-${KFMIN}:5
	net-libs/libpcap
	sys-apps/lm-sensors:=
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXres
	webengine? (
		>=dev-qt/qtwebchannel-${QTMIN}:5
		>=dev-qt/qtwebengine-${QTMIN}:5
	)
"
DEPEND="${RDEPEND}
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	x11-base/xorg-proto
"
BDEPEND="sys-libs/libcap"

# downstream patch
PATCHES=( "${FILESDIR}/${PN}-5.22.80-no-detailed-mem-message.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package webengine Qt5WebChannel)
		$(cmake_use_find_package webengine Qt5WebEngineWidgets)
	)

	ecm_src_configure
}

src_test() {
	# bugs 797898, 889942: flaky test
	local myctestargs=(
		-E "(sensortreemodeltest)"
	)
	LC_NUMERIC="C" ecm_src_test # bug 695514
}
