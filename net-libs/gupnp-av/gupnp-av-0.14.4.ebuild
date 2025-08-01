# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala

DESCRIPTION="Utility library aiming to ease the handling UPnP A/V profiles"
HOMEPAGE="https://wiki.gnome.org/Projects/GUPnP https://gitlab.gnome.org/GNOME/gupnp-av"

LICENSE="LGPL-2"
SLOT="0/3" # subslot: soname version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc +introspection vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.58:2
	dev-libs/libxml2:=
	introspection? ( >=dev-libs/gobject-introspection-1.36:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? (
		>=dev-util/gi-docgen-2021.1
		app-text/docbook-xml-dtd:4.1.2
	)
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_setup
	default

	# This makes sense for upstream but not for us downstream, bug #906641.
	sed -i -e '/-Werror=deprecated-declarations/d' meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}
