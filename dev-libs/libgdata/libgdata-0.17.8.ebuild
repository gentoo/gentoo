# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="GLib-based library for accessing online service APIs using the GData protocol"
HOMEPAGE="https://wiki.gnome.org/Projects/libgdata"

LICENSE="LGPL-2.1+"
SLOT="0/22" # subslot = libgdata soname version

IUSE="+crypt gnome-online-accounts +introspection static-libs test vala"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	gnome-online-accounts? ( crypt )
	vala? ( introspection )
"

KEYWORDS="alpha amd64 ~arm ~arm64 hppa ~ia64 ~ppc ~ppc64 sparc x86"

RDEPEND="
	>=dev-libs/glib-2.38.0:2
	>=dev-libs/json-glib-0.15
	>=dev-libs/libxml2-2:2
	>=net-libs/liboauth-0.9.4
	>=net-libs/libsoup-2.55.90:2.4[introspection?]
	>=x11-libs/gdk-pixbuf-2.14:2
	crypt? ( app-crypt/gcr:= )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.8:= )
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.25
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	test? ( >=net-libs/uhttpmock-0.5 )
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# configure checks for gtk:3, but only uses it for demos which are not installed
	gnome2_src_configure \
		$(use_enable crypt gnome) \
		$(use_enable gnome-online-accounts goa) \
		$(use_enable introspection) \
		$(use_enable vala) \
		$(use_enable static-libs static) \
		$(use_enable test always-build-tests) \
		GTK_CFLAGS= \
		GTK_LIBS=
}

src_test() {
	unset ORBIT_SOCKETDIR
	export GSETTINGS_BACKEND="memory" #486412
	dbus-launch emake check
}
