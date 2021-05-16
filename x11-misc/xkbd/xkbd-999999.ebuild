# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic git-r3

DESCRIPTION="onscreen soft keyboard for X11"
HOMEPAGE="https://github.com/mahatma-kaganovich/xkbd"
EGIT_REPO_URI="https://github.com/mahatma-kaganovich/xkbd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug +evdev +xft +xi +xpm +xrandr +xscreensaver"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXtst
	evdev? ( dev-libs/libevdev )
	xft? ( x11-libs/libXft )
	xpm? ( x11-libs/libXpm )
	xrandr? ( x11-libs/libXrandr )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
DOCS=( AUTHORS )
PATCHES=(
	"${FILESDIR}"/${PN}-999999-evdev.patch
	"${FILESDIR}"/${PN}-999999-xft.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use debug && append-cppflags -DDEBUG
	econf \
		$(use_enable evdev) \
		$(use_enable xft) \
		$(use_enable xi) \
		$(use_enable xpm) \
		$(use_enable xrandr) \
		$(use_enable xscreensaver ss) \
		--disable-debug
}
