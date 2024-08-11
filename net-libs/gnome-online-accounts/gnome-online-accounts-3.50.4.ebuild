# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala xdg

DESCRIPTION="GNOME framework for accessing online accounts"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-online-accounts"

LICENSE="LGPL-2+"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

IUSE="debug gnome gtk-doc +introspection kerberos man ms365 +vala"
REQUIRED_USE="vala? ( introspection )"

# libsoup used in goaoauthprovider
# goa kerberos provider is incompatible with app-crypt/heimdal, see
# https://bugzilla.gnome.org/show_bug.cgi?id=692250
# json-glib-0.16 needed for bug #485092
RDEPEND="
	>=dev-libs/glib-2.67.4:2
	sys-apps/dbus
	introspection? ( >=dev-libs/gobject-introspection-0.6.2:= )
	>=gui-libs/libadwaita-1.4
	>=gui-libs/gtk-4.10:4
	>=dev-libs/json-glib-0.16
	>=app-crypt/libsecret-0.5
	>=net-libs/libsoup-3.0:3.0
	dev-libs/libxml2:2
	>=net-libs/rest-0.9.0:1.0
	kerberos? (
		>=app-crypt/gcr-4.1.0:4=[gtk]
		app-crypt/mit-krb5
	)
"
# goa-daemon can launch gnome-control-center
PDEPEND="gnome? ( >=gnome-base/gnome-control-center-3.2[gnome-online-accounts(+)] )"

DEPEND="${RDEPEND}
	vala? ( $(vala_depend) )
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.30.0
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig

	dev-libs/gobject-introspection-common
	gnome-base/gnome-common
"
BDEPEND="gtk-doc? ( dev-util/gtk-doc )"

src_prepare() {
	default
	use vala && vala_setup
}

src_configure() {
	# TODO: Give users a way to set the G/FB/Windows Live secrets
	local emesonargs=(
		-Dgoabackend=true
		-Dexchange=true
		-Dfedora=false
		-Dgoogle=true
		-Dimap_smtp=true
		$(meson_use kerberos)
		-Downcloud=true
		-Dwebdav=true
		-Dwindows_live=true
		$(meson_use gtk-doc gtk_doc)
		$(meson_use ms365 ms_graph)
		$(meson_use introspection)
		-Dman=true
		$(meson_use vala vapi)
	)
	meson_src_configure
}
