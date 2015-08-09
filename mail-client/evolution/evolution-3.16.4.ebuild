# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils flag-o-matic readme.gentoo gnome2

DESCRIPTION="Integrated mail, addressbook and calendaring functionality"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) CC-BY-SA-3.0 FDL-1.3+ OPENLDAP"
SLOT="2.0"
IUSE="+bogofilter crypt highlight ldap map spamassassin spell ssl +weather"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"

# We need a graphical pinentry frontend to be able to ask for the GPG
# password from inside evolution, bug 160302
PINENTRY_DEPEND="|| ( app-crypt/pinentry[gnome-keyring] app-crypt/pinentry[gtk] app-crypt/pinentry[qt4] )"

# glade-3 support is for maintainers only per configure.ac
# pst is not mature enough and changes API/ABI frequently
# dconf explicitely needed for backup plugin
# google tasks requires >=libgdata-0.15.1
# gnome-desktop support is optional with --enable-gnome-desktop
# gnome-autoar (currently disabled because no release has been made)
COMMON_DEPEND="
	>=app-crypt/gcr-3.4
	>=app-text/enchant-1.1.7
	>=dev-libs/glib-2.40:2[dbus]
	>=dev-libs/libgdata-0.10:=
	>=dev-libs/libxml2-2.7.3:2
	>=gnome-base/gnome-desktop-2.91.3:3=
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=gnome-extra/evolution-data-server-3.16:=[gtk,weather?]
	>=media-libs/libcanberra-0.25[gtk3]
	>=net-libs/libsoup-2.42:2.4
	>=net-libs/webkit-gtk-2.2:3
	>=x11-libs/cairo-1.9.15:=[glib]
	>=x11-libs/gdk-pixbuf-2.24:2
	>=x11-libs/gtk+-3.10:3
	>=x11-libs/libnotify-0.7:=
	>=x11-misc/shared-mime-info-0.22

	>=app-text/iso-codes-0.49
	dev-libs/atk
	gnome-base/dconf
	dev-libs/libical:=
	x11-libs/libSM
	x11-libs/libICE

	crypt? (
		>=app-crypt/gnupg-1.4
		${PINENTRY_DEPEND}
		x11-libs/libcryptui )
	map? (
		>=media-libs/libchamplain-0.12:0.12[gtk]
		>=media-libs/clutter-1.0.0:1.0
		>=media-libs/clutter-gtk-0.90:1.0
		>=sci-geosciences/geocode-glib-3.10.0
		x11-libs/mx:1.0 )
	spell? ( app-text/gtkspell:3 )
	ldap? ( >=net-nds/openldap-2:= )
	ssl? (
		>=dev-libs/nspr-4.6.1:=
		>=dev-libs/nss-3.11:= )
	weather? ( >=dev-libs/libgweather-3.8:2= )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40.0
	dev-util/itstool
	virtual/pkgconfig
"
# eautoreconf needs:
#	app-text/yelp-tools
#	>=gnome-base/gnome-common-2.12
RDEPEND="${COMMON_DEPEND}
	bogofilter? ( mail-filter/bogofilter )
	highlight? ( app-text/highlight )
	spamassassin? ( mail-filter/spamassassin )
	!gnome-extra/evolution-exchange
"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		app-text/yelp-tools
		doc? ( >=dev-util/gtk-doc-1.14 )"
fi

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="To change the default browser if you are not using GNOME, edit
~/.local/share/applications/mimeapps.list so it includes the
following content:

[Default Applications]
x-scheme-handler/http=firefox.desktop
x-scheme-handler/https=firefox.desktop

(replace firefox.desktop with the name of the appropriate .desktop
file from /usr/share/applications if you use a different browser)."

src_prepare() {
	# Fix relink issues in src_install
	ELTCONF="--reverse-deps"

	# Do not create Contacts source for GMail accounts (from 3.16 branch)
	epatch "${FILESDIR}"/${P}-contacts-gmail.patch

	gnome2_src_prepare

}

src_configure() {
	# Use NSS/NSPR only if 'ssl' is enabled.
	gnome2_src_configure \
		--without-glade-catalog \
		--disable-autoar \
		--disable-code-coverage \
		--disable-installed-tests \
		--disable-pst-import \
		--enable-canberra \
		$(use_enable crypt libcryptui) \
		$(use_enable highlight text-highlight) \
		$(use_enable map contact-maps) \
		$(use_enable spell gtkspell) \
		$(use_enable ssl nss) \
		$(use_enable ssl smime) \
		$(use_with bogofilter) \
		$(use_with ldap openldap) \
		$(use_with spamassassin) \
		$(usex ssl --enable-nss=yes "--without-nspr-libs
			--without-nspr-includes
			--without-nss-libs
			--without-nss-includes") \
		$(use_enable weather)
}

src_install() {
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS* README"

	gnome2_src_install

	# Problems with prelink:
	# https://bugzilla.gnome.org/show_bug.cgi?id=731680
	# https://bugzilla.gnome.org/show_bug.cgi?id=732148
	# https://bugzilla.redhat.com/show_bug.cgi?id=1114538
	echo PRELINK_PATH_MASK=/usr/bin/evolution > ${T}/99${PN}
	doenvd "${T}"/99${PN}

	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}
