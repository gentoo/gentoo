# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="A helper library for Wayland compositors"
HOMEPAGE="https://github.com/Cloudef/wlc"

SRC_URI="https://github.com/Cloudef/wlc/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X static-libs systemd"

RDEPEND="virtual/opengl
	media-libs/mesa[wayland,gbm,gles2,egl]
	x11-libs/libdrm
	x11-libs/pixman
	x11-libs/libxkbcommon
	x11-misc/xkeyboard-config
	dev-libs/libinput
	dev-libs/wayland
	X? ( x11-libs/libX11
		 x11-libs/libxcb
		 x11-libs/xcb-util-image
		 x11-libs/xcb-util-wm
		 x11-libs/libXfixes )
	systemd? ( sys-apps/systemd sys-apps/dbus )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-libs/wayland-protocols"

src_configure() {
	local mycmakeargs=(
		-DWLC_BUILD_EXAMPLES=OFF
		-DWLC_BUILD_TESTS=OFF

		-DWLC_BUILD_STATIC=$(usex static-libs)

		-DWLC_X11_SUPPORT=$(usex X)

		$(cmake-utils_use_find_package systemd Systemd)
		$(cmake-utils_use_find_package systemd Dbus)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	if use X && !has_version 'x11-base/xorg-server[wayland]'
	then
		elog "You have enabled wlc's X11 support. To use Xwayland, you must emerge"
		elog "'x11-base/xorg-server[wayland]'."
	fi
}
