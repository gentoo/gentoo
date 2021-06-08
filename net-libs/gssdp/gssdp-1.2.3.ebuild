# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson-multilib vala xdg

DESCRIPTION="GObject-based API for handling resource discovery and announcement over SSDP"
HOMEPAGE="https://wiki.gnome.org/Projects/GUPnP"

LICENSE="LGPL-2+"
SLOT="0/1.2-0" # <API version>-<soname>
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~ppc ppc64 ~sparc x86"
IUSE="gtk-doc +introspection gtk vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.54:2[${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.26.1:2.4[${MULTILIB_USEDEP},introspection?]
	gtk? ( >=x11-libs/gtk+-3.12:3 )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	gtk-doc? ( >=dev-util/gtk-doc-1.14
		app-text/docbook-xml-dtd:4.1.2 )
	virtual/pkgconfig
	vala? (
		$(vala_depend)
		net-libs/libsoup:2.4[vala]
	)
"

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_bool gtk-doc gtk_doc)
		$(meson_native_use_bool gtk sniffer)
		$(meson_native_use_bool introspection)
		$(meson_native_use_bool vala vapi)
		-Dexamples=false
	)
	meson_src_configure
}
