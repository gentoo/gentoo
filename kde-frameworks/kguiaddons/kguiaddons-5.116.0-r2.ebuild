# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.9
inherit ecm frameworks.kde.org xdg

DESCRIPTION="Framework providing assorted high-level user interface components"

LICENSE="LGPL-2+"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE="dbus wayland X"

# slot op: includes qpa/qplatformnativeinterface.h
COMMON_DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	dbus? ( >=dev-qt/qtdbus-${QTMIN}:5 )
	wayland? (
		dev-libs/wayland
		>=dev-qt/qtgui-${QTMIN}:5=[wayland]
		>=dev-qt/qtwayland-${QTMIN}:5
	)
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
	)
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
	wayland? ( >=dev-libs/plasma-wayland-protocols-1.7.0 )
	X? ( x11-libs/libxcb )
"
RDEPEND="${COMMON_DEPEND}
	kde-frameworks/kguiaddons:6
"
BDEPEND="wayland? ( >=dev-qt/qtwaylandscanner-${QTMIN}:5 )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_GEO_SCHEME_HANDLER=OFF
		-DWITH_DBUS=$(usex dbus)
		-DWITH_WAYLAND=$(usex wayland)
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}
