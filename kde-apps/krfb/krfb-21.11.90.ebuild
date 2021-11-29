# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.88.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="VNC-compatible server to share Plasma desktops"
HOMEPAGE="https://apps.kde.org/krfb/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/plasma-wayland-protocols-1.5.0
	dev-libs/wayland
	>=dev-qt/qtdbus-${QTMIN}:5
	|| (
		>=dev-qt/qtgui-${QTMIN}:5[libinput]
		>=dev-qt/qtgui-${QTMIN}:5[X]
	)
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwayland-${QTMIN}:5
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
	media-libs/libepoxy
	media-libs/mesa[gbm(+)]
	>=media-video/pipewire-0.3:=
	>=net-libs/libvncserver-0.9.9
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXtst
	x11-libs/xcb-util-image
"
DEPEND="${COMMON_DEPEND}
	media-libs/libglvnd
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/xdg-desktop-portal[screencast]
"
