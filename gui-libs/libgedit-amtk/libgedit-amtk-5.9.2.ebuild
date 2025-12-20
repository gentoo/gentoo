# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Actions, Menus and Toolbars Kit for GTK applications"
HOMEPAGE="https://gitlab.gnome.org/World/gedit/libgedit-amtk"
SRC_URI="https://gitlab.gnome.org/World/gedit/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="5/0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="+introspection gtk-doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	!gui-libs/amtk
	>=dev-libs/glib-2.56:2
	>=x11-libs/gtk+-3.22:3[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
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
		$(meson_use test tests)
	)
	meson_src_configure
}
