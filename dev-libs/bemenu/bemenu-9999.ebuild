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
IUSE="doc ncurses wayland X"

# Require at least one backend be built
REQUIRED_USE="|| ( ncurses wayland X )"

DEPEND="
	ncurses? ( sys-libs/ncurses:0 )
	wayland? (
		dev-libs/wayland
		dev-libs/wayland-protocols
		x11-libs/cairo
		x11-libs/pango
	)
	X? (
		x11-libs/libxcb
		x11-libs/libXext
		x11-libs/libX11
		x11-libs/cairo[X]
		x11-libs/pango[X]
	)
"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

src_configure() {
	local mycmakeargs=(
		-DCURSES_LIBRARY=/usr/$(get_libdir)/libncursesw.so
		-DBEMENU_CURSES_RENDERER=$(usex ncurses ON OFF)
		-DBEMENU_WAYLAND_RENDERER=$(usex wayland ON OFF)
		-DBEMENU_X11_RENDERER=$(usex X ON OFF)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
