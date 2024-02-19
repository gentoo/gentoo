# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing access to properties and features of the window manager"

LICENSE="|| ( LGPL-2.1 LGPL-3 ) MIT"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="wayland X"

RESTRICT="test"

RDEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
	test? ( >=dev-qt/qtwidgets-${QTMIN}:5 )
"
BDEPEND=">=dev-qt/linguist-tools-${QTMIN}:5"
PDEPEND="wayland? ( >=kde-plasma/kwayland-integration-5.25.5-r1:5 )"

DOCS=( docs/README.kstartupinfo )

src_configure() {
	local mycmakeargs=(
		-DKWINDOWSYSTEM_NO_WIDGETS=ON
		$(cmake_use_find_package X X11)
	)

	ecm_src_configure
}
