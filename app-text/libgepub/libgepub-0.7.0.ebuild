# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson xdg

DESCRIPTION="GObject based library for handling and rendering epub documents"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libgepub"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+introspection widget"

RDEPEND="
	net-libs/libsoup:3
	dev-libs/glib:2
	dev-libs/libxml2
	app-arch/libarchive
	widget? ( net-libs/webkit-gtk:4.1 )
	gui-libs/gtk:4
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		$(meson_use introspection)
		$(meson_use widget)
	)
	meson_src_configure
}
