# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="Email client for GNOME"
HOMEPAGE="http://pawsa.fedorapeople.org/balsa/"
SRC_URI="http://pawsa.fedorapeople.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

IUSE="crypt gnome gtkhtml gnome-keyring +gtkspell kerberos ldap libnotify rubrica sqlite ssl webkit xface"
REQUIRED_USE="gtkhtml? ( !webkit )"

# TODO: esmtp can be optional, do we want it?
RDEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.4.0:3
	dev-libs/gmime:2.6
	>=net-libs/libesmtp-1.0.3:=
	net-mail/mailbase
	media-libs/libcanberra:=[gtk3]
	x11-themes/hicolor-icon-theme
	x11-themes/gnome-icon-theme
	crypt? ( >=app-crypt/gpgme-1.0:= )
	gnome? ( >=x11-libs/gtksourceview-3.2.0:3.0 )
	gnome-keyring? ( app-crypt/libsecret )
	gtkhtml? ( gnome-extra/gtkhtml:4.0 )
	sqlite? ( >=dev-db/sqlite-2.8:= )
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	gtkspell? ( >=app-text/gtkspell-3.0.3:3 )
	!gtkspell? ( app-text/enchant )
	kerberos? ( app-crypt/mit-krb5 )
	ldap? ( net-nds/openldap )
	rubrica? ( dev-libs/libxml2:2 )
	ssl? ( dev-libs/openssl:= )
	webkit? ( net-libs/webkit-gtk:4 )
	xface? ( >=media-libs/compface-1.5.1:= )
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
"

src_prepare() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README TODO docs/*"

	# https://bugzilla.gnome.org/show_bug.cgi?id=750516
	sed -i -e 's/@TOOLKIT_CATEGORIES@//' balsa-mailto-handler.desktop.in.in || die

	# https://bugzilla.gnome.org/show_bug.cgi?id=750515
	echo "src/balsa-print-object.c" >> po/POTFILES.in || die

	gnome2_src_prepare
}

src_configure() {
	local myconf

	if use crypt ; then
		myconf+=" --with-gpgme=gpgme-config"
	else
		myconf+=" --without-gpgme"
	fi

	if use webkit || use gtkhtml; then
		if use gtkhtml ; then
			myconf+=" --with-html-widget=gtkhtml4"
		else
			myconf+=" --with-html-widget=webkit2"
		fi
	else
		myconf+=" --with-html-widget=no"
	fi

	gnome2_src_configure \
		--disable-pcre \
		--enable-gregex \
		--enable-threads \
		--with-gmime=2.6 \
		--with-canberra \
		$(use_with gnome) \
		$(use_with gnome gtksourceview) \
		$(use_with gnome-keyring libsecret) \
		$(use_with gtkspell) \
		$(use_with kerberos gss) \
		$(use_with ldap) \
		$(use_with libnotify) \
		$(use_with rubrica) \
		$(use_with sqlite) \
		$(use_with ssl) \
		$(use_with xface compface) \
		${myconf}
}
