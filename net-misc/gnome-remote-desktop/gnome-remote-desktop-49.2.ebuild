# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson systemd tmpfiles xdg

DESCRIPTION="Remote desktop server which allows you to connect to your machine remotely"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-remote-desktop"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong"
IUSE="doc +rdp systemd +vnc"
REQUIRED_USE="|| ( rdp vnc )"
RESTRICT="test" # Tests run xvfb-run directly

DEPEND="
	x11-libs/cairo
	x11-libs/libdrm
	>=media-libs/libepoxy-1.4
	>=dev-libs/glib-2.75:2
	>=dev-libs/libei-1.3.901
	x11-libs/libnotify
	app-crypt/libsecret
	>=media-video/pipewire-1.2.0:=
	app-crypt/tpm2-tss:=
	rdp? (
		>=media-libs/nv-codec-headers-11.1.5.0
		>=net-misc/freerdp-3.15.0:=[server]
		>=sys-fs/fuse-3.9.1:3=
		media-libs/libva
		>=sys-auth/polkit-122
		>=dev-util/vulkan-headers-1.2.0
		media-libs/shaderc
		dev-util/spirv-tools
		>=x11-libs/libxkbcommon-1.0.0
		media-libs/fdk-aac:=
	)
	vnc? (
		net-libs/libvncserver
	)
"
RDEPEND="${DEPEND}
	acct-user/gnome-remote-desktop
	acct-group/gnome-remote-desktop
	x11-wm/mutter[screencast]
"
BDEPEND="
	>=dev-build/meson-1.4.0
	dev-libs/glib
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
		$(meson_use rdp)
		$(meson_use vnc)
		$(meson_use systemd)
		-Dsystemd_user_unit_dir="$(systemd_get_userunitdir)"
		-Dtests=false  # Tests run xvfb-run directly
	)
	meson_src_configure
}

pkg_postinst() {
	tmpfiles_process "${PN}-tmpfiles.conf"
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
