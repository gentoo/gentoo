# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="GLib-based library for accessing online service APIs using the GData protocol"
HOMEPAGE="https://wiki.gnome.org/Projects/libgdata"

LICENSE="LGPL-2.1+"
SLOT="0/22" # subslot = libgdata soname version

IUSE="+crypt gnome-online-accounts gtk-doc +introspection test vala"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="!test? ( test )"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/json-glib-0.15[introspection?]
	>=dev-libs/libxml2-2:2
	>=net-libs/libsoup-2.55.90:2.4[introspection?,vala?]
	crypt? ( app-crypt/gcr:0= )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.8:=[introspection?,vala?] )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		>=net-libs/uhttpmock-0.5.0:0
		>=x11-libs/gdk-pixbuf-2.14:2
	)
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_src_prepare
	gnome2_environment_reset
	# Don't waste time building a couple small demos that aren't installed
	sed -i -e '/subdir.*demos/d' meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dgtk=disabled # only for demos
		$(meson_feature crypt gnome)
		$(meson_feature gnome-online-accounts goa)
		-Doauth1=disabled
		$(meson_use test always_build_tests)
		-Dinstalled_tests=false
		-Dman=true
		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)
		$(meson_use vala vapi)
	)
	meson_src_configure
}
