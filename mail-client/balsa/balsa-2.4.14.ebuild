# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/balsa/balsa-2.4.14.ebuild,v 1.7 2015/06/07 12:02:58 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="Email client for GNOME"
HOMEPAGE="http://pawsa.fedorapeople.org/balsa/"
SRC_URI="http://pawsa.fedorapeople.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"
# Doesn't currently build with -gnome
IUSE="crypt gnome +gtkspell kerberos ldap libnotify networkmanager rubrica sqlite ssl webkit xface"

# TODO: esmtp can be optional
RDEPEND="
	>=dev-libs/glib-2.16:2
	>=x11-libs/gtk+-2.18:2
	dev-libs/gmime:2.6
	dev-libs/libunique:1
	>=net-libs/libesmtp-1.0.3:=
	net-mail/mailbase
	media-libs/libcanberra:=[gtk]
	x11-themes/hicolor-icon-theme
	crypt? ( >=app-crypt/gpgme-1.0:= )
	gnome? (
		>=gnome-base/orbit-2
		>=gnome-base/libbonobo-2.0
		>=gnome-base/libgnome-2.0
		>=gnome-base/libgnomeui-2.0
		>=gnome-base/gconf-2.0:2
		>=gnome-base/gnome-keyring-2.20
		>=x11-libs/gtksourceview-2.10:2.0 )
	sqlite? ( >=dev-db/sqlite-2.8:= )
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	gtkspell? (
		app-text/gtkspell:2
		app-text/enchant )
	!gtkspell? ( app-text/aspell )
	kerberos? ( app-crypt/mit-krb5 )
	ldap? ( net-nds/openldap )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	rubrica? ( dev-libs/libxml2:2 )
	ssl? ( dev-libs/openssl:= )
	webkit? ( >=net-libs/webkit-gtk-1.5.1:2 )
	xface? ( >=media-libs/compface-1.5.1:= )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	>=app-text/scrollkeeper-0.1.4
	app-text/gnome-doc-utils
"

src_prepare() {
	# Fix documentation
	epatch "${FILESDIR}/${PN}-2.4.11-doc-fixes.patch"
	gnome2_src_prepare
}

src_configure() {
	local myconf
	DOCS="AUTHORS ChangeLog HACKING NEWS README TODO docs/*"

	if use crypt ; then
		myconf+=" --with-gpgme=gpgme-config"
	else
		myconf+=" --without-gpgme"
	fi

	if use webkit; then
		myconf+=" --with-html-widget=webkit"
	else
		myconf+=" --with-html-widget=no"
	fi

	gnome2_src_configure \
		--disable-pcre \
		--enable-gregex \
		--enable-threads \
		--with-gmime=2.6 \
		--with-unique \
		--with-canberra \
		$(use_with gnome) \
		$(use_with gnome gtksourceview) \
		$(use_with gtkspell) \
		$(use_with kerberos gss) \
		$(use_with ldap) \
		$(use_with libnotify) \
		$(use_with networkmanager nm) \
		$(use_with rubrica) \
		$(use_with sqlite) \
		$(use_with ssl) \
		$(use_with xface compface) \
		${myconf}
}
