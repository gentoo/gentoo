# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2 meson

DESCRIPTION="Actions, Menus and Toolbars Kit for GTK applications"
HOMEPAGE="https://github.com/gedit-technology/libgedit-amtk"
SRC_URI="https://gedit-technology.net/tarballs/libgedit-amtk/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="5/0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+introspection gtk-doc"

RDEPEND="
	!gui-libs/amtk
	>=dev-libs/glib-2.56:2
	>=x11-libs/gtk+-3.22:3
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3
	)
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use introspection gobject_introspection)
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}
