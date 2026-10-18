# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KFMIN=6.30.0
QTMIN=6.11.2
inherit ecm plasma.kde.org xdg

DESCRIPTION="Screenshot capture utility"
HOMEPAGE="https://apps.kde.org/spectacle/"

LICENSE="LGPL-2+ handbook? ( FDL-1.3 )"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="share X"

# qtbase slot op: Uses qtx11extras_p.h and qpa/qplatformnativeinterface.h
COMMON_DEPEND="
	app-text/tesseract:=
	dev-libs/wayland
	>=dev-qt/qtbase-${QTMIN}:6=[concurrent,dbus,gui,wayland,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6[qml]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X?]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/prison-${KFMIN}:6
	>=kde-plasma/kpipewire-${KDE_CATV}:6
	>=kde-plasma/layer-shell-qt-${KDE_CATV}:6
	>=media-libs/kquickimageeditor-0.7.0.1:6
	share? ( >=kde-frameworks/purpose-${KFMIN}:6 )
	X? (
		>=dev-qt/qtbase-${QTMIN}:6[X]
		x11-libs/libxcb
		x11-libs/libXrandr
		x11-libs/xcb-util
		x11-libs/xcb-util-cursor
		x11-libs/xcb-util-image
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/plasma-wayland-protocols-1.22.0
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtimageformats-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kimageformats-${KFMIN}:6
"
BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[wayland]
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=$(usex X)
		$(cmake_use_find_package share KF6Purpose)
	)
	ecm_src_configure
}
