# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org meson xdg

DESCRIPTION="GObject based library for handling and rendering epub documents"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libgepub"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~sparc x86"
IUSE="+introspection"

RDEPEND="
	app-arch/libarchive
	dev-libs/glib:2
	dev-libs/libxml2
	net-libs/libsoup:2.4
	net-libs/webkit-gtk:4
	x11-libs/gtk+:3
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	meson_src_configure \
		$(meson_use introspection)
}
