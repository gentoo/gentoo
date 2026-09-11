# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-3)
KFMIN=6.27.0
QTMIN=6.11.2
inherit ecm gear.kde.org xdg

DESCRIPTION="Quake-style terminal emulator based on konsole"
HOMEPAGE="https://apps.kde.org/yakuake/"

LICENSE="GPL-2 LGPL-2"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="X"

# slot op: Uses Qt6::GuiPrivate for qtx11extras_p.h
RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,wayland,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-apps/konsole-${PVCUT}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X?]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	kde-plasma/kwayland:6
	X? (
		>=dev-qt/qtbase-${QTMIN}:6=[X]
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/xcb-util
	)
"
DEPEND="${RDEPEND}
	dev-libs/plasma-wayland-protocols
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[wayland]
	dev-util/wayland-scanner
"

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}
