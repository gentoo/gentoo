# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="VNC-compatible server to share Plasma desktops"
HOMEPAGE="https://apps.kde.org/krfb/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="wayland"

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdnssd-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=net-libs/libvncserver-0.9.9
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXtst
	x11-libs/xcb-util-image
	wayland? (
		dev-libs/wayland
		|| (
			>=dev-qt/qtgui-${QTMIN}:5[libinput]
			>=dev-qt/qtgui-${QTMIN}:5[X]
		)
		>=dev-qt/qtwayland-${QTMIN}:5
		>=kde-frameworks/kwayland-${KFMIN}:5
		kde-plasma/kpipewire:5
		media-libs/libepoxy
		media-libs/mesa[gbm(+)]
		>=media-video/pipewire-0.3:=
	)
"
DEPEND="${COMMON_DEPEND}
	wayland? (
		>=dev-libs/plasma-wayland-protocols-1.5.0
		media-libs/libglvnd
	)
"
RDEPEND="${COMMON_DEPEND}
	wayland? ( sys-apps/xdg-desktop-portal[screencast] )
"
BDEPEND="wayland? ( >=dev-qt/qtwaylandscanner-${QTMIN}:5 )"

src_configure() {
	local mycmakeargs=(
		-DDISABLE_PIPEWIRE=$(usex !wayland)
		$(cmake_use_find_package wayland PlasmaWaylandProtocols)
		$(cmake_use_find_package wayland gbm)
		$(cmake_use_find_package wayland EGL)
		$(cmake_use_find_package wayland epoxy)
	)
	ecm_src_configure
}
