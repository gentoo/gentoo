# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="flickr applications for GNOME"
HOMEPAGE="https://live.gnome.org/Frogr"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/glib-2.56:2
	>=dev-libs/json-glib-1.1.2
	>=dev-libs/libgcrypt-1.5:=
	>=dev-libs/libxml2-2.6.8:2
	media-libs/gstreamer:1.0
	>=media-libs/libexif-0.6.14
	>=net-libs/libsoup-3.0:3.0
	>=x11-libs/gtk+-3.16:3[introspection]
	x11-libs/gdk-pixbuf:2
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	dev-util/itstool
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"
# TODO add a useflag for enable-video or header-bar???
# libsoup2 option not needed

pkg_postinst() {
	xdg_pkg_postinst
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	xdg_icon_cache_update
	gnome2_schemas_update
}
