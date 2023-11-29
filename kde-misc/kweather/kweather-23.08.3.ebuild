# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="utilities"
ECM_TEST="false"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Weather forecast application for Plasma with flat and dynamic/animated views"
HOMEPAGE="https://apps.kde.org/kweather/"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 arm64 ~loong ~ppc64 x86"

DEPEND="
	>=dev-libs/kirigami-addons-0.6:5
	>=dev-libs/kweathercore-0.6:5
	>=dev-qt/qtcharts-${QTMIN}:5[qml]
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kholidays-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-plasma/libplasma-${KFMIN}:5
"
RDEPEND="${DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtpositioning-${QTMIN}:5[geoclue]
"

src_prepare() {
	ecm_src_prepare

	sed -e "/include(ECMCheckOutboundLicense)/s/^/#DONT /" \
		-e "/ecm_check_outbound_license/s/^/#DONT /" \
		-i CMakeLists.txt || die # avoid cmake spam about python, reusetool
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_PLASMOID=ON
	)
	ecm_src_configure
}
