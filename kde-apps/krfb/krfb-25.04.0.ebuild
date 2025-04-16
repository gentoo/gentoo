# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=6.9.0
QTMIN=6.7.2
inherit ecm gear.kde.org xdg

DESCRIPTION="VNC-compatible server to share Plasma desktops"
HOMEPAGE="https://apps.kde.org/krfb/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="wayland"

# slot op: Uses Qt::GuiPrivate for qtx11extras_p.h
COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6=[dbus,network,widgets,X]
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kdnssd-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=net-libs/libvncserver-0.9.9
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXtst
	x11-libs/xcb-util-image
	wayland? (
		dev-libs/wayland
		>=dev-qt/qtwayland-${QTMIN}:6
		kde-plasma/kpipewire:6
		kde-plasma/kwayland:6
		>=media-video/pipewire-0.3
	)
"
DEPEND="${COMMON_DEPEND}
	wayland? ( >=dev-libs/plasma-wayland-protocols-1.5.0 )
"
RDEPEND="${COMMON_DEPEND}
	wayland? ( sys-apps/xdg-desktop-portal[screencast(+)] )
"
BDEPEND="wayland? ( >=dev-qt/qtwayland-${QTMIN}:6 )"

src_configure() {
	local mycmakeargs=(
		-DDISABLE_PIPEWIRE=$(usex !wayland)
		$(cmake_use_find_package wayland PlasmaWaylandProtocols)
	)
	ecm_src_configure
}
