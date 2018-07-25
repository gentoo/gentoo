# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 eutils cmake-utils

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="http://swaywm.org/"

EGIT_REPO_URI="https://github.com/swaywm/sway.git"
EGIT_BRANCH="0.15"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+gdk-pixbuf +swaybar +swaybg swaygrab swaylock +swaymsg systemd +tray wallpapers zsh-completion"

REQUIRED_USE="tray? ( swaybar )"

RDEPEND="=dev-libs/wlc-9999[systemd=]
	dev-libs/json-c:0=
	dev-libs/libpcre
	dev-libs/libinput
	dev-libs/wayland
	sys-libs/libcap
	x11-libs/libxkbcommon
	x11-libs/cairo
	x11-libs/pango
	gdk-pixbuf? ( x11-libs/gdk-pixbuf[jpeg] )
	swaylock? ( virtual/pam )
	tray? ( sys-apps/dbus )"

DEPEND="${RDEPEND}
	app-text/asciidoc
	virtual/pkgconfig"

src_prepare() {
	cmake-utils_src_prepare

	# remove bad CFLAGS that upstream is trying to add
	sed -i -e '/add_compile_options/s/-Werror//' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-Denable-swaybar=$(usex swaybar)
		-Denable-swaybg=$(usex swaybg)
		-Denable-swaygrab=$(usex swaygrab)
		-Denable-swaylock=$(usex swaylock)
		-Denable-swaymsg=$(usex swaymsg)
		-Denable-tray=$(usex tray)

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
	if use swaygrab
	then
		optfeature "swaygrab screenshot support" media-gfx/imagemagick[png]
		optfeature "swaygrab video capture support" virtual/ffmpeg
	fi
	if use tray
	then
		optfeature "experimental xembed tray icons support" \
			x11-misc/xembedsniproxy
	fi
	optfeature "X11 applications support" dev-libs/wlc[xwayland] x11-base/xorg-server[wayland]

}
