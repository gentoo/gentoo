# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_PYTHON_BINDINGS="off"
QTMIN=6.7.2
inherit ecm frameworks.kde.org xdg

DESCRIPTION="Framework providing assorted high-level user interface components"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="dbus wayland X"

# slot op: includes qpa/qplatformnativeinterface.h
COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus?,gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	wayland? (
		dev-libs/wayland
		>=dev-qt/qtbase-${QTMIN}:6=[wayland]
		>=dev-qt/qtwayland-${QTMIN}:6
	)
	X? (
		>=dev-qt/qtbase-${QTMIN}:6[X]
		x11-libs/libX11
	)
"
DEPEND="${COMMON_DEPEND}
	wayland? ( >=dev-libs/plasma-wayland-protocols-1.15.0 )
	X? (
		x11-base/xorg-proto
		x11-libs/libxcb
	)
"
RDEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:5[-kf6compat(-)]
"
BDEPEND="
	wayland? (
		>=dev-qt/qtwayland-${QTMIN}:6
		dev-util/wayland-scanner
	)
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_GEO_SCHEME_HANDLER=ON
		-DUSE_DBUS=$(usex dbus)
		-DWITH_WAYLAND=$(usex wayland)
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}
