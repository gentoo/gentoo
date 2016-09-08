# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MATE_LA_PUNT="yes"

inherit mate multilib

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Personal file sharing for the MATE desktop"
LICENSE="GPL-2"
SLOT="0"

IUSE="X gtk3"

RDEPEND="
	>=dev-libs/dbus-glib-0.70:0
	>=dev-libs/glib-2.15.2:2
	>=mate-base/caja-1.6[gtk3(-)=]
	>=sys-apps/dbus-1.1.1:0
	>=x11-libs/gdk-pixbuf-2:2
	x11-libs/libX11:0
	x11-libs/pango:0
	>=x11-libs/libnotify-0.7:0
	>=www-apache/mod_dnssd-0.6:0
	>=www-servers/apache-2.2:2[apache2_modules_dav,apache2_modules_dav_fs,apache2_modules_authn_file,apache2_modules_auth_digest,apache2_modules_authz_groupfile]
	virtual/libintl:0
	!gtk3? (
		>=dev-libs/libunique-1:1
		media-libs/libcanberra:0[gtk]
		>=x11-libs/gtk+-2.24:2
	)
	gtk3? (
		>=dev-libs/libunique-3:3
		media-libs/libcanberra:0[gtk3]
		>=x11-libs/gtk+-3.0:3
	)"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools:0
	>=dev-util/intltool-0.35:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"

src_configure() {
	mate_src_configure \
		--with-httpd=apache2 \
		--with-modules-path=/usr/$(get_libdir)/apache2/modules/ \
		--disable-bluetooth \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_with X x)
}
