# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2

DESCRIPTION="Email client for GNOME"
HOMEPAGE="http://pawsa.fedorapeople.org/balsa/"
SRC_URI="http://pawsa.fedorapeople.org/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"

IUSE="gnome +gnome-keyring kerberos ldap rubrica sqlite webkit xface"

# TODO: internal spell checking via enchant-2 instead of gtkspell/gspell?
DEPEND="
	>=dev-libs/glib-2.48.0:2
	>=x11-libs/gtk+-3.24.0:3
	>=dev-libs/gmime-3.2.6:3.0
	>=net-libs/gnutls-3.0:=
	dev-libs/fribidi
	dev-libs/libical:=
	webkit? (
		>=net-libs/webkit-gtk-2.28.0:4
		>=dev-db/sqlite-3.24:=
		app-text/html2text
	)
	>=app-crypt/gpgme-1.13.0:=
	sqlite? ( >=dev-db/sqlite-3.24:= )
	ldap? ( net-nds/openldap:= )
	rubrica? ( dev-libs/libxml2:2 )
	kerberos? ( app-crypt/mit-krb5 )
	xface? ( >=media-libs/compface-1.5.1:= )
	gnome? ( x11-libs/gtksourceview:4 )
	media-libs/libcanberra:=[gtk3]
	gnome-keyring? ( app-crypt/libsecret )
	>=app-text/gspell-1.6:0=

	net-mail/mailbase
	x11-themes/hicolor-icon-theme
	x11-themes/adwaita-icon-theme
	dev-libs/openssl:0=
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/gtk-update-icon-cache
	dev-util/intltool
	dev-util/itstool
	virtual/pkgconfig
	sys-devel/gettext
	dev-libs/libxml2:2
"

DOCS="AUTHORS ChangeLog HACKING NEWS README TODO docs/*"

src_configure() {
	local myconf=(
		$(use_with gnome)
		$(use_enable sqlite autocrypt)
		--with-canberra
		$(use_with xface compface)
		$(use_with kerberos gss)
		$(usex webkit --with-html-widget=webkit2 --with-html-widget=no)
		$(use_with gnome gtksourceview)
		--with-spell-checker=gspell
		$(use_with ldap)
		$(use_with rubrica)
		--without-osmo
		$(use_with sqlite)
		$(use_with gnome-keyring libsecret)
		--without-gcr # experimental
	)
	gnome2_src_configure "${myconf[@]}"
}
