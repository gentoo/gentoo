# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson xdg vala

DESCRIPTION="NetworkManager GUI library"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
# pkcs11 default enabled as it's a small dep often already present by libnma users, and it was default enabled as IUSE=+gcr in nm-applet before
IUSE="gtk-doc +introspection +pkcs11 vala"
REQUIRED_USE="vala? ( introspection )"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

DEPEND="
	app-text/iso-codes
	net-misc/mobile-broadband-provider-info
	>=dev-libs/glib-2.38:2
	>=x11-libs/gtk+-3.10:3[introspection?]
	>=net-misc/networkmanager-1.7[introspection?]
	pkcs11? ( >=app-crypt/gcr-3.14:= )
	introspection? ( >=dev-libs/gobject-introspection-1.56:= )
"
RDEPEND="${DEPEND}
	!<gnome-extra/nm-applet-1.16.0" # gschema moved to here before nm-applet-1.16.0
BDEPEND="
	dev-libs/libxml2
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3 )
	vala? ( $(vala_depend)
		net-misc/networkmanager[vala]
	)
"

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dlibnma_gtk4=false
		$(meson_use pkcs11 gcr)
		-Dmore_asserts=0
		-Diso_codes=true
		-Dmobile_broadband_provider_info=true
		-Dld_gc=false
		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
