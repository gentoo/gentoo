# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"
GNOME2_EAUTORECONF="yes"

inherit gnome.org meson vala xdg

DESCRIPTION="GLib-based library for accessing online service APIs using the GData protocol"
HOMEPAGE="https://wiki.gnome.org/Projects/libgdata"

LICENSE="LGPL-2.1+"
SLOT="0/22" # subslot = libgdata soname version

IUSE="+crypt gnome-online-accounts gtk gtk-doc +introspection test vala"
# needs dconf
RESTRICT="test"

REQUIRED_USE="
	gnome-online-accounts? ( crypt )
	vala? ( introspection )
"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/json-glib-1[introspection?]
	>=dev-libs/libxml2-2:2
	>=net-libs/liboauth-0.9.4
	>=net-libs/libsoup-2.55.90:2.4[introspection?]
	gtk? ( x11-libs/gtk+:3 )
	crypt? ( app-crypt/gcr:= )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.8:=[introspection?,vala?] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.25
	sys-devel/gettext
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	test? ( >=net-libs/uhttpmock-0.5
		>=x11-libs/gdk-pixbuf-2.14:2 )
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	eapply_user
}

src_configure() {
	local emesonargs=(
		"-Dinstalled_tests=false"
		-Dgnome=$(usex crypt enabled disabled)
		-Dgoa=$(usex gnome-online-accounts enabled disabled)
		-Dgtk=$(usex gtk enabled disabled)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use gtk-doc man)
		$(meson_use introspection)
		$(meson_use vala vapi)
		$(meson_use test always-build-tests)
	)
	meson_src_configure
}

src_test() {
	meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
