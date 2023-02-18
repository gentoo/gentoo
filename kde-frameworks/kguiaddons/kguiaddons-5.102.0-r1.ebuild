# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="false"
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing assorted high-level user interface components"

LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="dbus wayland X"

# slot op: includes qpa/qplatformnativeinterface.h
RDEPEND="
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
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	wayland? ( >=dev-libs/plasma-wayland-protocols-1.7.0 )
	X? ( x11-libs/libxcb )
"
BDEPEND="wayland? ( >=dev-qt/qtwaylandscanner-${QTMIN}:5 )"

PATCHES=( "${FILESDIR}/${P}-fix-waylandclipboard.patch" ) # KDE-bug 463199

src_configure() {
	local mycmakeargs=(
		-DWITH_DBUS=$(usex dbus)
		-DWITH_WAYLAND=$(usex wayland)
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}
