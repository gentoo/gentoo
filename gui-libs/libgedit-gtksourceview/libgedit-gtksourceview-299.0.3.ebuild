# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson virtualx xdg

DESCRIPTION="Gedit Technology - Source code editing widget"
HOMEPAGE="https://github.com/gedit-technology/libgedit-gtksourceview"
SRC_URI="https://gedit-technology.net/tarballs/libgedit-gtksourceview/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="300"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="gtk-doc"

RDEPEND="
	>=dev-libs/glib-2.74:2
	>=x11-libs/gtk+-3.20:3
	>=dev-libs/libxml2-2.6:2

	dev-libs/gobject-introspection:=
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
		-Dgobject_introspection=true
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}

src_test() {
	virtx dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
}
