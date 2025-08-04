# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_PYTHON_BINDINGS="off"
QTMIN=6.7.2
inherit ecm frameworks.kde.org xdg

DESCRIPTION="Framework providing assorted high-level user interface components"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE="dbus wayland X"

# slot op: includes qpa/qplatformnativeinterface.h
COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus?,gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	wayland? (
		dev-libs/wayland
		>=dev-qt/qtbase-${QTMIN}:6=[wayland]
	)
	X? (
		>=dev-qt/qtbase-${QTMIN}:6[X]
		x11-libs/libX11
	)
"
DEPEND="${COMMON_DEPEND}
	wayland? (
		>=dev-libs/plasma-wayland-protocols-1.15.0
		>=dev-libs/wayland-protocols-1.39
	)
	X? (
		x11-base/xorg-proto
		x11-libs/libxcb
	)
"
RDEPEND="${COMMON_DEPEND}
	!<kde-frameworks/kguiaddons-5.116.0-r2:5[-kf6compat(-)]
"
RDEPEND+=" wayland? ( || ( >=dev-qt/qtbase-6.10:6[wayland] <dev-qt/qtwayland-6.10:6 ) )"
BDEPEND="
	wayland? (
		>=dev-qt/qtbase-${QTMIN}:6[wayland]
		dev-util/wayland-scanner
	)
"
BDEPEND+=" wayland? ( || ( >=dev-qt/qtbase-6.10:6[wayland] <dev-qt/qtwayland-6.10:6 ) )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_GEO_SCHEME_HANDLER=ON
		-DUSE_DBUS=$(usex dbus)
		-DWITH_WAYLAND=$(usex wayland)
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}
