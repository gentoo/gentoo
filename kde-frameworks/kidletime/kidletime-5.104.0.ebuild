# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="false"
QTMIN=5.15.5
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for detection and notification of device idle time"

LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="wayland X xscreensaver"

REQUIRED_USE="xscreensaver? ( X )"

RDEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	wayland? (
		dev-libs/wayland
		>=dev-qt/qtgui-${QTMIN}:5=[wayland]
		>=dev-qt/qtwayland-${QTMIN}:5
	)
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libXext
	)
	xscreensaver? (
		>=dev-qt/qtdbus-${QTMIN}:5
		x11-libs/libXScrnSaver
	)
"
DEPEND="${RDEPEND}
	wayland? (
		>=dev-libs/plasma-wayland-protocols-1.7.0
		>=dev-libs/wayland-protocols-1.27:0
	)
"
BDEPEND="wayland? ( >=dev-qt/qtwaylandscanner-${QTMIN}:5 )"

src_prepare() {
	ecm_src_prepare
	if ! use xscreensaver; then
		sed -i -e "s/\${X11_Xscreensaver_FOUND}/0/" CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package wayland Qt5WaylandClient)
		$(cmake_use_find_package X X11)
		$(cmake_use_find_package X XCB)
	)

	ecm_src_configure
}
