# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="false"
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for detection and notification of device idle time"

LICENSE="LGPL-2+"
KEYWORDS="~amd64"
IUSE="wayland X xscreensaver"

REQUIRED_USE="xscreensaver? ( X )"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	wayland? (
		dev-libs/wayland
		>=dev-qt/qtbase-${QTMIN}:6=[wayland]
		>=dev-qt/qtwayland-${QTMIN}:6
	)
	X? (
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libXext
	)
	xscreensaver? (
		>=dev-qt/qtbase-${QTMIN}:6[dbus]
		x11-libs/libXScrnSaver
	)
"
DEPEND="${RDEPEND}
	wayland? (
		>=dev-libs/plasma-wayland-protocols-1.11.1
		>=dev-libs/wayland-protocols-1.27:0
	)
"
BDEPEND="wayland? ( >=dev-qt/qtwayland-${QTMIN}:6 )"

src_prepare() {
	ecm_src_prepare
	if ! use xscreensaver; then
		sed -i -e "s/\${X11_Xscreensaver_FOUND}/0/" CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWITH_WAYLAND=$(usex wayland)
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}
