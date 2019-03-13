# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake-utils

DESCRIPTION="dmenu clone for wayland"
HOMEPAGE="https://github.com/Cloudef/bemenu"
EGIT_REPO_URI="https://github.com/Cloudef/bemenu.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DEPEND="
	x11-libs/cairo
	x11-libs/pango
	dev-libs/wayland
	x11-libs/libxcb
	dev-libs/wayland-protocols
	sys-libs/ncurses:0
	x11-libs/libXext
	x11-libs/libX11"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

src_configure() {
	local mycmakeargs=(-DCURSES_LIBRARY=/usr/$(get_libdir)/libncursesw.so)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
