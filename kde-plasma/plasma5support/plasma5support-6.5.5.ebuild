# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=6.18.0
QTMIN=6.10.1
inherit ecm plasma.kde.org

DESCRIPTION="Support components for porting from KF5/Qt5 to KF6/Qt6"

LICENSE="GPL-2+ LGPL-2+"
SLOT="6"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="activities geolocation ksysguard X"

RESTRICT="test" # bug 926347

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,sql,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/kholidays-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kidletime-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kunitconversion-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	activities? ( >=kde-plasma/plasma-activities-${KDE_CATV}:6= )
	geolocation? ( >=kde-frameworks/networkmanager-qt-${KFMIN}:6 )
	ksysguard? ( >=kde-plasma/libksysguard-${KDE_CATV}:6 )
	X? ( x11-libs/libX11 )
"
RDEPEND="${DEPEND}
	!kde-plasma/plasma-workspace:5
	!<kde-plasma/plasma-workspace-6.4.90:6
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package activities PlasmaActivities)
		$(cmake_use_find_package geolocation KF6NetworkManagerQt)
		$(cmake_use_find_package ksysguard KSysGuard)
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}
