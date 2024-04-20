# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 gnome2-utils meson optfeature vala

DESCRIPTION="Browse the Fediverse (GTK client)"
HOMEPAGE="
	https://tuba.geopjr.dev/
	https://github.com/GeopJr/Tuba/
"
EGIT_REPO_URI="https://github.com/GeopJr/Tuba.git"

LICENSE="GPL-3 CC-BY-SA-4.0"
SLOT="0"

# TODO: optional dep on libspelling-1
DEPEND="
	app-crypt/libsecret[introspection,vala]
	>=dev-libs/glib-2.76.0:2
	>=dev-libs/json-glib-1.4.4[introspection]
	>=dev-libs/libgee-0.8.5:0.8[introspection]
	dev-libs/libxml2
	>=gui-libs/gtk-4.11.3:4[gstreamer,introspection]
	>=gui-libs/libadwaita-1.4:1[introspection,vala]
	>=gui-libs/gtksourceview-5.6.0:5[introspection,vala]
	net-libs/libsoup:3.0[introspection,vala]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	$(vala_depend)
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		# disable calling updaters (see pkg_post*)
		-Ddistro=true
	)

	vala_setup
	meson_src_configure
}

src_install() {
	meson_src_install
	dosym dev.geopjr.Tuba /usr/bin/tuba
}

pkg_postinst() {
	optfeature "WebP image support" gui-libs/gdk-pixbuf-loader-webp

	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}
