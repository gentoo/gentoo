# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org meson xdg

DESCRIPTION="Collection of developer-oriented UPnP tools"
HOMEPAGE="https://wiki.gnome.org/Projects/GUPnP"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	>=net-libs/gssdp-1.2.0:=
	>=net-libs/gupnp-1.2.0:=
	>=net-libs/libsoup-2.42:2.4
	>=net-libs/gupnp-av-0.5.5:0=
	>=x11-libs/gtk+-3.10:3
	>=dev-libs/glib-2.24:2
	>=dev-libs/libxml2-2.4:2
	x11-libs/gtksourceview:4
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dav-tools=true
	)
	meson_src_configure
}
