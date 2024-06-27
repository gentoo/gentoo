# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KF5MIN=5.115.0
KFMIN=6.3.0
PVCUT=$(ver_cut 1-3)
QT5MIN=5.15.12
QTMIN=6.7.1
inherit ecm plasma.kde.org

DESCRIPTION="Qt Platform Theme integration plugins for the Plasma workspaces"

LICENSE="LGPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="qt5"

# requires running kde environment
RESTRICT="test"

# slot ops: qdbus*_p.h and Qt6::GuiPrivate for qtx11extras_p.h
COMMON_DEPEND="
	dev-libs/wayland
	>=dev-qt/qtbase-${QTMIN}:6=[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtwayland-${QTMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	x11-libs/libXcursor
	x11-libs/libxcb
	qt5? (
		>=dev-qt/qtdbus-${QT5MIN}:5
		>=dev-qt/qtgui-${QT5MIN}:5=[dbus]
		>=dev-qt/qtquickcontrols2-${QT5MIN}:5
		>=dev-qt/qtwayland-${QT5MIN}:5
		>=dev-qt/qtwidgets-${QT5MIN}:5
		>=dev-qt/qtx11extras-${QT5MIN}:5
		>=kde-frameworks/kcompletion-${KF5MIN}:5
		>=kde-frameworks/kconfig-${KF5MIN}:5
		>=kde-frameworks/kconfigwidgets-${KF5MIN}:5
		>=kde-frameworks/kcoreaddons-${KF5MIN}:5
		>=kde-frameworks/kguiaddons-${KF5MIN}:5
		>=kde-frameworks/ki18n-${KF5MIN}:5
		>=kde-frameworks/kiconthemes-${KF5MIN}:5
		>=kde-frameworks/kio-${KF5MIN}:5
		>=kde-frameworks/kjobwidgets-${KF5MIN}:5
		>=kde-frameworks/knotifications-${KF5MIN}:5
		>=kde-frameworks/kwindowsystem-${KF5MIN}:5
		>=kde-frameworks/kxmlgui-${KF5MIN}:5
		>=kde-plasma/kwayland-${KF5MIN}:5
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/plasma-wayland-protocols-1.13.0
"
RDEPEND="${COMMON_DEPEND}
	media-fonts/hack
	media-fonts/noto
	media-fonts/noto-emoji
"
PDEPEND="
	>=kde-plasma/xdg-desktop-portal-kde-${PVCUT}:6
"
BDEPEND="
	>=dev-qt/qtwayland-${QTMIN}:6
	qt5? ( >=dev-qt/qtwaylandscanner-${QT5MIN}:5 )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_QT6=ON
		-DBUILD_QT5=$(usex qt5)
	)
	ecm_src_configure
}
