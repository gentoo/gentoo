# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Email client for GNOME"
HOMEPAGE="http://pawsa.fedorapeople.org/balsa/"
SRC_URI="http://pawsa.fedorapeople.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

IUSE="crypt gnome gnome-keyring kerberos ldap libnotify libressl rubrica sqlite webkit xface"

# TODO: internal spell checking via enchant-2 instead of gtkspell/gspell?
RDEPEND="
	>=app-text/gspell-1.2:0=
	>=dev-libs/glib-2.40.0:2
	net-libs/gnutls:=
	>=x11-libs/gtk+-3.10.0:3
	dev-libs/gmime:2.6
	net-mail/mailbase
	media-libs/libcanberra:=[gtk3]
	x11-themes/hicolor-icon-theme
	x11-themes/adwaita-icon-theme
	crypt? ( >=app-crypt/gpgme-1.5.0:= )
	gnome? ( >=x11-libs/gtksourceview-3.2.0:3.0 )
	gnome-keyring? ( app-crypt/libsecret )
	sqlite? ( >=dev-db/sqlite-2.8:= )
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	kerberos? ( app-crypt/mit-krb5 )
	ldap? ( net-nds/openldap )
	rubrica? ( dev-libs/libxml2:2 )
	webkit? (
		net-libs/webkit-gtk:4
		app-text/html2text
	)
	xface? ( >=media-libs/compface-1.5.1:= )
"
DEPEND="${RDEPEND}
	dev-util/gtk-update-icon-cache
	app-text/yelp-tools
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	dev-libs/libxml2:2
"

PATCHES=( "$FILESDIR"/${P}-fix-older-webkit{1,2}.patch )
DOCS="AUTHORS ChangeLog HACKING NEWS README TODO docs/*"

src_configure() {
	gnome2_src_configure \
		--with-canberra \
		--with-spell-checker=gspell \
		$(usex crypt --with-gpgme=gpgme-config --without-gpgme) \
		$(use_with gnome) \
		$(use_with gnome gtksourceview) \
		$(use_with gnome-keyring libsecret) \
		$(use_with kerberos gss) \
		$(use_with ldap) \
		$(use_with libnotify) \
		$(use_with rubrica) \
		$(use_with sqlite) \
		$(use_with xface compface) \
		$(usex webkit --with-html-widget=webkit2 --with-html-widget=no)
}
