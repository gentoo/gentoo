# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing access to properties and features of the window manager"

LICENSE="|| ( LGPL-2.1 LGPL-3 ) MIT"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="wayland X"

RESTRICT="test"

# slot op: Uses Qt6::GuiPrivate for qtx11extras_p.h
# slot op: Uses private/qwayland*_p.h headers
# x11-base/xorg-proto: X11/Xlib.h included in public header kkeyserver.h,
#   req. by KF6WindowSystemConfig.cmake; see also bug #939177
RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,wayland?]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	wayland? ( >=dev-qt/qtwayland-${QTMIN}:6= )
	X? (
		>=dev-qt/qtbase-${QTMIN}:6=[gui,X]
		x11-base/xorg-proto
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
"
DEPEND="${RDEPEND}
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
