# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mate-extra/mate-user-share/mate-user-share-1.8.0.ebuild,v 1.6 2015/07/12 00:02:09 np-hardass Exp $

EAPI="5"

GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Personal file sharing for the MATE desktop"
HOMEPAGE="http://www.mate-desktop.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="X bluetooth"

RDEPEND=">=app-mobilephone/obex-data-server-0.4:0
	>=dev-libs/dbus-glib-0.70:0
	>=dev-libs/glib-2.15.2:2
	>=dev-libs/libunique-1:1
	>=mate-base/caja-1.8:0
	media-libs/libcanberra:0[gtk]
	>=sys-apps/dbus-1.1.1:0
	>=x11-libs/gdk-pixbuf-2:2
	>=x11-libs/gtk+-2.14:2
	x11-libs/libX11:0
	x11-libs/pango:0
	>=x11-libs/libnotify-0.7:0
	>=www-apache/mod_dnssd-0.6:0
	>=www-servers/apache-2.2:2[apache2_modules_dav,apache2_modules_dav_fs,apache2_modules_authn_file,apache2_modules_auth_digest,apache2_modules_authz_groupfile]
	virtual/libintl:0
	bluetooth? ( >=net-wireless/bluez-4.18:0= )"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools:0
	>=dev-util/intltool-0.35:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"

src_configure() {
	gnome2_src_configure \
		--with-httpd=apache2 \
		--with-modules-path=/usr/$(get_libdir)/apache2/modules/ \
		$(use_enable bluetooth) \
		$(use_with X x)
}

DOCS="AUTHORS ChangeLog NEWS README"
