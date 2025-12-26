# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.116.0
QTMIN=5.15.17
inherit ecm plasma.kde.org xdg

DESCRIPTION="Qt Platform Theme integration plugins for the Plasma workspaces"

LICENSE="LGPL-2+"
SLOT="5"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

# requires running kde environment
RESTRICT="test"

COMMON_DEPEND="
	dev-libs/wayland
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5=[dbus]
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtwayland-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-plasma/kwayland-${KFMIN}:5
	x11-libs/libXcursor
	x11-libs/libxcb
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/plasma-wayland-protocols-1.19.0
"
RDEPEND="${COMMON_DEPEND}
	!<${CATEGORY}/${PN}-6.5.2-r1:6[qt5]
	>=${CATEGORY}/${PN}-6.5.0:6[-qt5(-)]
	media-fonts/hack
	media-fonts/noto
	media-fonts/noto-emoji
"
BDEPEND=">=dev-qt/qtwaylandscanner-${QTMIN}:5"

src_configure() {
	local mycmakeargs=(
		-DBUILD_QT6=OFF
		-DBUILD_QT5=ON
	)
	ecm_src_configure
}
