# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala virtualx

DESCRIPTION="Shumate is a GTK toolkit providing widgets for embedded maps"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libshumate"

LICENSE="LGPL-2.1+"
SLOT="1.0/1"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~sparc ~x86"
REQUIRED_USE="gtk-doc? ( introspection )"

IUSE="gtk-doc +introspection sysprof vala"

RDEPEND="
	>=dev-libs/glib-2.74.0:2
	>=x11-libs/cairo-1.4
	>=dev-db/sqlite-1.12:3
	>=gui-libs/gtk-4:4
	>=net-libs/libsoup-3.0:3.0
	introspection? ( >=dev-libs/gobject-introspection-0.6.3:= )
	>=dev-libs/json-glib-1.6.0[introspection?]
	dev-libs/protobuf-c
"
DEPEND="${RDEPEND}
	sysprof? ( dev-util/sysprof-capture:4 )
"
BDEPEND="
	gtk-doc? ( >=dev-util/gi-docgen-2021.1 )
	vala? ( $(vala_depend) )
"

src_configure() {
	local emesonargs=(
		$(meson_use introspection gir)
		$(meson_use vala vapi)
		$(meson_use gtk-doc gtk_doc)
		-Ddemos=false # only built, not installed
		-Dvector_renderer=true
		$(meson_feature sysprof)
	)
	meson_src_configure
}

src_test() {
	virtx dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
}

src_install() {
	meson_src_install
	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html || die
		mv "${ED}"/usr/share/doc/libshumate-1.0 "${ED}"/usr/share/gtk-doc/html/libshumate-1.0 || die
	fi
}
