# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic gnome.org gnome2-utils meson xdg vala

DESCRIPTION="NetworkManager GUI library"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
# pkcs11 default enabled as it's a small dep often already present by libnma users, and it was default enabled as IUSE=+gcr in nm-applet before
IUSE="X gtk-doc +introspection +pkcs11 vala"
REQUIRED_USE="vala? ( introspection )"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"

DEPEND="
	>=gui-libs/gtk-4.0:4[X?]
	app-text/iso-codes
	net-misc/mobile-broadband-provider-info
	>=dev-libs/glib-2.38:2
	>=x11-libs/gtk+-3.12:3[X?,introspection?]
	>=net-misc/networkmanager-1.7[introspection?]
	pkcs11? ( >=app-crypt/gcr-4.0.0:4= )
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
	default
	use vala && vala_setup
	xdg_environment_reset
}

src_configure() {
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11

	local emesonargs=(
		-Dlibnma_gtk4=true
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

src_install() {
	meson_src_install
	rm "${D}/usr/share/glib-2.0/schemas/org.gnome.nm-applet.gschema.xml" || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
