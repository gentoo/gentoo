# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=6.18.0
QTMIN=6.10.1
inherit ecm plasma.kde.org xdg

DESCRIPTION="KDE Plasma screen management"
HOMEPAGE="https://invent.kde.org/plasma/kscreen"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~ppc64"
IUSE="X"

# slot op: Uses Qt6GuiPrivate and Qt6WaylandClientPrivate
COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6=[dbus,gui,wayland,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-plasma/layer-shell-qt-${KDE_CATV}:6
	>=kde-plasma/libkscreen-${KDE_CATV}:6=
	>=kde-plasma/libplasma-${KDE_CATV}:6
	X? (
		>=dev-qt/qtbase-${QTMIN}:6[X]
		x11-libs/libX11
		x11-libs/libxcb:=
		x11-libs/libXi
	)
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	!ppc64? ( >=kde-frameworks/kimageformats-${KFMIN}:6[avif] )
	>=kde-plasma/kglobalacceld-${KDE_CATV}:6
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/wayland-protocols-1.41
"
BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[wayland]
	dev-util/wayland-scanner
	>=kde-frameworks/kcmutils-${KFMIN}:6
	virtual/pkgconfig
"

CMAKE_SKIP_TESTS=(
	# last checked 2025-07-17, also fails upstream
	# FAIL!  : TestConfig::testDisabledScreenConfig() Compared values are not the same
	kscreen-kded-configtest
)

src_prepare() {
	ecm_src_prepare
	use ppc64 && cmake_comment_add_subdirectory hdrcalibrator # avif masked on big-endian
}

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}
