# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.6.0
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing access to properties and features of the window manager"

LICENSE="|| ( LGPL-2.1 LGPL-3 ) MIT"
KEYWORDS="~amd64"
IUSE="wayland X"

RESTRICT="test"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	wayland? ( >=dev-qt/qtwayland-${QTMIN}:6 )
	X? (
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
	test? ( >=dev-qt/qtbase-${QTMIN}:6[widgets] )
	wayland? (
		dev-libs/plasma-wayland-protocols
		>=dev-libs/wayland-protocols-1.21
	)
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

DOCS=( docs/README.kstartupinfo )

src_configure() {
	local mycmakeargs=(
		-DKWINDOWSYSTEM_WAYLAND=$(usex wayland)
		-DKWINDOWSYSTEM_X11=$(usex X)
	)

	ecm_src_configure
}
