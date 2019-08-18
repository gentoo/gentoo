# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson systemd xdg

DESCRIPTION="Remote desktop daemon for GNOME using pipewire"
HOMEPAGE="https://gitlab.gnome.org/jadahl/gnome-remote-desktop"
SRC_URI="https://gitlab.gnome.org/jadahl/gnome-remote-desktop/uploads/ed3e8b8ebc1a74b6f4ed7260a2739f40/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

DEPEND="
	dev-libs/glib:2
	>=media-video/pipewire-0.2.5:0/0.2
	sys-apps/systemd
	net-libs/libvncserver
	app-crypt/libsecret
	x11-libs/libnotify
"
RDEPEND="${DEPEND}
	x11-wm/mutter[screencast]
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dsystemd_user_unit_dir="$(systemd_get_userunitdir)"
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
