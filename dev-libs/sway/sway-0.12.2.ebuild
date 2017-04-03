# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="http://swaywm.org/"

SRC_URI="https://github.com/SirCmpwn/sway/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+swaybg +swaybar +swaymsg swaygrab swaylock +gdk-pixbuf zsh-completion wallpapers systemd"

RDEPEND=">=dev-libs/wlc-0.0.8[systemd=]
	dev-libs/json-c
	dev-libs/libpcre
	dev-libs/libinput
	x11-libs/libxkbcommon
	dev-libs/wayland
	sys-libs/libcap
	x11-libs/pango
	x11-libs/cairo
	swaylock? ( virtual/pam )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf[jpeg] )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-text/asciidoc"

src_prepare() {
	cmake-utils_src_prepare

	# remove bad CFLAGS that upstream is trying to add
	sed -i -e '/FLAGS.*-Werror/d' CMakeLists.txt || die
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
		-DGIT_COMMIT_HASH="${PVR}" # specify version info, may change in future
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
	optfeature "X11 applications support" dev-libs/wlc[xwayland] x11-base/xorg-server[wayland]
}
