# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Email client for GNOME"
HOMEPAGE="http://pawsa.fedorapeople.org/balsa/"
SRC_URI="http://pawsa.fedorapeople.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

IUSE="crypt gnome gnome-keyring kerberos ldap libnotify libressl rubrica sqlite webkit xface"

# TODO: esmtp can be optional, do we want it?
RDEPEND="
	>=app-text/gspell-1.2:0=
	>=dev-libs/glib-2.40.0:2
	>=x11-libs/gtk+-3.10.0:3
	dev-libs/gmime:2.6
	>=net-libs/libesmtp-1.0.3:=
	net-mail/mailbase
	media-libs/libcanberra:=[gtk3]
	x11-themes/hicolor-icon-theme
	x11-themes/adwaita-icon-theme
	crypt? ( >=app-crypt/gpgme-1.2.0:= )
	gnome? ( >=x11-libs/gtksourceview-3.2.0:3.0 )
	gnome-keyring? ( app-crypt/libsecret )
	sqlite? ( >=dev-db/sqlite-2.8:= )
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	kerberos? ( app-crypt/mit-krb5 )
	ldap? ( net-nds/openldap )
	rubrica? ( dev-libs/libxml2:2 )
	webkit? ( net-libs/webkit-gtk:4 )
	xface? ( >=media-libs/compface-1.5.1:= )
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-python/html2text
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
