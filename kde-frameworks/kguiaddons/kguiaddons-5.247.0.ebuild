# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="false"
QTMIN=6.6.0
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing assorted high-level user interface components"

LICENSE="LGPL-2+"
KEYWORDS="~amd64"
IUSE="dbus wayland X"

# slot op: includes qpa/qplatformnativeinterface.h
COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus?,gui]
	wayland? (
		dev-libs/wayland
		>=dev-qt/qtbase-${QTMIN}:6=[wayland]
		>=dev-qt/qtwayland-${QTMIN}:6
	)
	X? ( x11-libs/libX11 )
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
	wayland? ( >=dev-libs/plasma-wayland-protocols-1.11.1 )
	X? ( x11-libs/libxcb )
"
RDEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:5[-kf6compat(-)]
"
BDEPEND="wayland? ( >=dev-qt/qtwayland-${QTMIN}:6 )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_GEO_SCHEME_HANDLER=ON
		-DWITH_DBUS=$(usex dbus)
		-DWITH_WAYLAND=$(usex wayland)
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}
