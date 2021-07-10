# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework providing assorted high-level user interface components"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="wayland"

RDEPEND="
	>=dev-qt/qtgui-${QTMIN}:5[wayland?]
	>=dev-qt/qtx11extras-${QTMIN}:5
	x11-libs/libX11
	wayland? (
		dev-libs/wayland
		>=dev-qt/qtwayland-${QTMIN}:5
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libxcb
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PythonModuleGeneration=ON # bug 746866
		-DWITH_WAYLAND=$(usex wayland)
	)
	ecm_src_configure
}
