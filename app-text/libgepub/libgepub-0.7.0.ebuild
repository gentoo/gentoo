# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson xdg

DESCRIPTION="GObject based library for handling and rendering epub documents"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libgepub"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="-widget +introspection"

RDEPEND="
	app-arch/libarchive
	dev-libs/glib:2
	dev-libs/libxml2
	net-libs/libsoup:3.0
	x11-libs/gtk+:3
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
	widget? ( >=net-libs/webkit-gtk-2.38.0:4.1 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	meson_src_configure \
		$(meson_use introspection) \
		$(meson_use widget)
}
