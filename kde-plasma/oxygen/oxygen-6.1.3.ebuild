# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KF5MIN=5.115.0
KFMIN=6.3.0
PVCUT=$(ver_cut 1-3)
QT5MIN=5.15.12
QTMIN=6.7.1
inherit ecm plasma.kde.org

DESCRIPTION="Oxygen visual style for the Plasma desktop"
HOMEPAGE="https://invent.kde.org/plasma/oxygen"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="qt5 X"

# slot op: Uses Qt6::GuiPrivate for qtx11extras_p.h
RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/frameworkintegration-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-plasma/kdecoration-${PVCUT}:6
	>=kde-plasma/libplasma-${PVCUT}:6
	qt5? (
		>=dev-qt/qtdbus-${QT5MIN}:5
		>=dev-qt/qtdeclarative-${QT5MIN}:5
		>=dev-qt/qtgui-${QT5MIN}:5
		>=dev-qt/qtwidgets-${QT5MIN}:5
		>=kde-frameworks/frameworkintegration-${KF5MIN}:5
		>=kde-frameworks/kcompletion-${KF5MIN}:5
		>=kde-frameworks/kconfig-${KF5MIN}:5
		>=kde-frameworks/kconfigwidgets-${KF5MIN}:5
		>=kde-frameworks/kcoreaddons-${KF5MIN}:5
		>=kde-frameworks/kguiaddons-${KF5MIN}:5
		>=kde-frameworks/ki18n-${KF5MIN}:5
		>=kde-frameworks/kwidgetsaddons-${KF5MIN}:5
		>=kde-frameworks/kwindowsystem-${KF5MIN}:5
		X? ( >=dev-qt/qtx11extras-${QT5MIN}:5 )
	)
	X? (
		>=dev-qt/qtbase-${QTMIN}:6=[gui]
		x11-libs/libxcb
	)
"
DEPEND="${RDEPEND}
	>=kde-frameworks/kservice-${KFMIN}:6
"
PDEPEND=">=kde-plasma/kde-cli-tools-${PVCUT}:*"

src_configure() {
	local mycmakeargs=(
		-DBUILD_QT6=ON
		-DBUILD_QT5=$(usex qt5)
		$(cmake_use_find_package X XCB)
	)
	ecm_src_configure
}
