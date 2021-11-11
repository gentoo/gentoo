# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="GNOME framework for accessing online accounts"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeOnlineAccounts"

LICENSE="LGPL-2+"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~sparc ~x86"

IUSE="debug gnome +introspection kerberos +vala"
REQUIRED_USE="vala? ( introspection )"

# pango used in goaeditablelabel
# libsoup used in goaoauthprovider
# goa kerberos provider is incompatible with app-crypt/heimdal, see
# https://bugzilla.gnome.org/show_bug.cgi?id=692250
# json-glib-0.16 needed for bug #485092
RDEPEND="
	>=dev-libs/glib-2.52:2
	>=app-crypt/libsecret-0.5
	>=dev-libs/json-glib-0.16
	dev-libs/libxml2:2
	>=net-libs/libsoup-2.42:2.4
	net-libs/rest:0.7
	>=net-libs/webkit-gtk-2.26.0:4
	>=x11-libs/gtk+-3.19.12:3
	x11-libs/pango

	introspection? ( >=dev-libs/gobject-introspection-0.6.2:= )
	kerberos? (
		app-crypt/gcr:0=[gtk]
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

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# TODO: Give users a way to set the G/FB/Windows Live secrets
	gnome2_src_configure \
		--disable-static \
		--enable-backend \
		--enable-documentation \
		--enable-exchange \
		--enable-facebook \
		--enable-flickr \
		--enable-foursquare \
		--enable-imap-smtp \
		--enable-lastfm \
		--enable-media-server \
		--enable-owncloud \
		--enable-windows-live \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable kerberos) \
		$(use_enable kerberos fedora) \
		$(use_enable introspection) \
		$(use_enable vala)
}
