# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson systemd xdg

DESCRIPTION="Remote desktop daemon for GNOME using pipewire"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-remote-desktop"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="aac doc +rdp systemd +vnc"
REQUIRED_USE="|| ( rdp vnc ) aac? ( rdp )"
RESTRICT="test" # Tests run xvfb-run directly

DEPEND="
	x11-libs/cairo
	x11-libs/libdrm
	>=media-libs/libepoxy-1.4
	>=dev-libs/glib-2.68:2
	x11-libs/libnotify
	app-crypt/libsecret
	>=media-video/pipewire-0.3.49:=
	app-crypt/tpm2-tss:=
	rdp? (
		>=media-libs/nv-codec-headers-11.1.5.0
		>=net-misc/freerdp-2.8.0:=[server]
		>=sys-fs/fuse-3.9.1:3
		>=x11-libs/libxkbcommon-1.0.0

		aac? (
			media-libs/fdk-aac:=
		)
	)
	vnc? (
		net-libs/libvncserver
	)
"
RDEPEND="${DEPEND}
	x11-wm/mutter[screencast]
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	virtual/pkgconfig
	doc? (
		app-text/asciidoc
	)
"

src_configure() {
	local emesonargs=(
		$(meson_use doc man)
		$(meson_use aac fdk_aac)
		$(meson_use rdp)
		$(meson_use vnc)
		$(meson_use systemd)
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
