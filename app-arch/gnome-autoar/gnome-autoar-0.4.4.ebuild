# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson vala

DESCRIPTION="Automatic archives creating and extracting library"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-autoar"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="gtk gtk-doc +introspection test vala"
REQUIRED_USE="vala? ( introspection ) gtk-doc? ( gtk )"
RESTRICT="!test? ( test )"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	>=app-arch/libarchive-3.4.0
	>=dev-libs/glib-2.35.6:2
	gtk? ( >=x11-libs/gtk+-3.2:3[introspection?] )
	introspection? ( >=dev-libs/gobject-introspection-1.30.0:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-util/glib-utils
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3 )
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk)
		$(meson_feature introspection)
		$(meson_use vala vapi)
		$(meson_use test tests)
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}
