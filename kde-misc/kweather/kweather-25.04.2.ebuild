# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="utilities"
ECM_TEST="false"
KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org xdg

DESCRIPTION="Weather forecast application for Plasma with flat and dynamic/animated views"
HOMEPAGE="https://apps.kde.org/kweather/"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"

DEPEND="
	dev-libs/kirigami-addons:6
	dev-libs/kweathercore:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,opengl,widgets]
	>=dev-qt/qtcharts-${QTMIN}:6[qml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kholidays-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	kde-plasma/libplasma:6
"
RDEPEND="${DEPEND}
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=dev-qt/qtpositioning-${QTMIN}:6[geoclue]
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
