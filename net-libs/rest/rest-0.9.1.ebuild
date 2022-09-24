# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson

DESCRIPTION="Helper library for RESTful services"
HOMEPAGE="https://wiki.gnome.org/Projects/Librest"

LICENSE="LGPL-2.1"
SLOT="1.0" # librest_soversion
KEYWORDS="~amd64"
IUSE="gtk-doc +introspection test"
REQUIRED_USE="gtk-doc? ( introspection )"
RESTRICT="!test? ( test ) test" # Fails with FEATURES=network-sandbox

RDEPEND="
	>=dev-libs/glib-2.44.0:2
	>=net-libs/libsoup-2.99.2:3.0
	dev-libs/json-glib:0[introspection?]
	dev-libs/libxml2:2
	app-misc/ca-certificates
	introspection? ( >=dev-libs/gobject-introspection-1.74.0:= )
"
DEPEND="${RDEPEND}"
BDEPEND="gtk-doc? ( >=dev-util/gi-docgen-2021.6 )"

src_configure() {
	local emesonargs=(
		-Dca_certificates=true
		-Dca_certificates_path="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt
		$(meson_use introspection)
		-Dvapi=false
		-Dexamples=false
		$(meson_use gtk-doc gtk_doc)
		-Dsoup2=false
		$(meson_use test tests)
	)
	meson_src_configure
}
