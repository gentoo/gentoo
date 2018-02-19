# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils xdg-utils meson

DESCRIPTION="A simple GTK+ frontend for mpv"
HOMEPAGE="https://gnome-mpv.github.io/"
SRC_URI="https://github.com/gnome-mpv/gnome-mpv/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-libs/glib-2.44
	>=x11-libs/gtk+-3.20:3
	>=media-video/mpv-0.27[libmpv]
	media-libs/libepoxy"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
}
