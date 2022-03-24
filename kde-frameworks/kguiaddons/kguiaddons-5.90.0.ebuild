# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework providing assorted high-level user interface components"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"
IUSE="wayland X"

# slot op: includes qpa/qplatformnativeinterface.h
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
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	X? ( x11-libs/libxcb )
"
BDEPEND="
	wayland? ( || (
		>=dev-qt/qtwaylandscanner-${QTMIN}:5
		<dev-qt/qtwayland-5.15.3:5
	) )
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PythonModuleGeneration=ON # bug 746866
		-DWITH_WAYLAND=$(usex wayland)
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}
