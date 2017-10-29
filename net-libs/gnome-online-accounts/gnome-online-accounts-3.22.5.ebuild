# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="GNOME framework for accessing online accounts"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeOnlineAccounts"

LICENSE="LGPL-2+"
SLOT="0/1"
IUSE="debug gnome +introspection kerberos" # telepathy"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

# pango used in goaeditablelabel
# libsoup used in goaoauthprovider
# goa kerberos provider is incompatible with app-crypt/heimdal, see
# https://bugzilla.gnome.org/show_bug.cgi?id=692250
# json-glib-0.16 needed for bug #485092
RDEPEND="
	>=dev-libs/glib-2.40:2
	>=app-crypt/libsecret-0.5
	>=dev-libs/json-glib-0.16
	dev-libs/libxml2:2
	>=net-libs/libsoup-2.42:2.4
	net-libs/rest:0.7
	net-libs/telepathy-glib
	>=net-libs/webkit-gtk-2.7.2:4
	>=x11-libs/gtk+-3.19.12:3
	x11-libs/pango

	introspection? ( >=dev-libs/gobject-introspection-0.6.2:= )
	kerberos? (
		app-crypt/gcr:0=[gtk]
		app-crypt/mit-krb5 )
"
#	telepathy? ( net-libs/telepathy-glib )
# goa-daemon can launch gnome-control-center
PDEPEND="gnome? ( >=gnome-base/gnome-control-center-3.2[gnome-online-accounts(+)] )"

DEPEND="${RDEPEND}
	$(vala_depend)
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.3
	>=dev-util/gdbus-codegen-2.30.0
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig

	dev-libs/gobject-introspection-common
	gnome-base/gnome-common
"
# eautoreconf needs gobject-introspection-common, gnome-common

# Due to sub-configure
QA_CONFIGURE_OPTIONS=".*"

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	# TODO: Give users a way to set the G/FB/Windows Live secrets
	# telepathy optional support is really a badly one, bug #494456
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
		--enable-pocket \
		--enable-telepathy \
		--enable-windows-live \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable kerberos)
		#$(use_enable telepathy)
	# gudev & cheese from sub-configure is overriden
	# by top level configure, and disabled so leave it like that
}
