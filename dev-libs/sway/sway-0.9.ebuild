# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils cmake-utils

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="http://swaywm.org/"

SRC_URI="https://github.com/SirCmpwn/sway/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+swaybg +swaybar +swaymsg swaygrab swaylock +gdk-pixbuf zsh-completion wallpapers systemd"

RDEPEND=">=dev-libs/wlc-0.0.5[systemd=]
	dev-libs/json-c
	dev-libs/libpcre
	dev-libs/libinput
	x11-libs/libxkbcommon
	dev-libs/wayland
	x11-libs/pango
	x11-libs/cairo
	swaylock? ( virtual/pam )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf[jpeg] )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-text/asciidoc"

src_prepare() {
	default

	# remove bad CFLAGS that upstream is trying to add
	sed -i -e '/FLAGS.*-Werror/d' -e '/FLAGS.*-g/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-Denable-swaybar=$(usex swaybar)
		-Denable-swaybg=$(usex swaybg)
		-Denable-swaygrab=$(usex swaygrab)
		-Denable-swaylock=$(usex swaylock)
		-Denable-swaymsg=$(usex swaymsg)

		-Ddefault-wallpaper=$(usex wallpapers)

		-Denable-gdk-pixbuf=$(usex gdk-pixbuf)
		-Dzsh-completions=$(usex zsh-completion)

		-DCMAKE_INSTALL_SYSCONFDIR="/etc"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	use !systemd && fperms u+s /usr/bin/sway
}

pkg_postinst() {
	if use swaygrab; then
		optfeature "swaygrab screenshot support" media-gfx/imagemagick[png]
		optfeature "swaygrab video capture support" virtual/ffmpeg
	fi
}
