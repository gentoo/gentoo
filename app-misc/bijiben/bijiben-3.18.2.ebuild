# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="Note editor designed to remain simple to use"
HOMEPAGE="https://wiki.gnome.org/Apps/Bijiben"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zeitgeist"

RDEPEND="
	>=app-misc/tracker-1:=
	>=dev-libs/glib-2.28:2
	dev-libs/libxml2
	>=gnome-extra/evolution-data-server-3.13.90:=
	net-libs/gnome-online-accounts
	net-libs/webkit-gtk:3
	sys-apps/util-linux
	>=x11-libs/gtk+-3.11.4:3
	zeitgeist? ( gnome-extra/zeitgeist )
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig

	app-text/yelp-tools
"
# Needed by eautoreconf:
#	app-text/yelp-tools

src_prepare() {
	# Fix zeitgeist automagic dependency
	# https://bugzilla.gnome.org/show_bug.cgi?id=756013
	epatch "${FILESDIR}"/${PN}-3.18.2-zeitgeist-automagic.patch
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable zeitgeist) \
		--disable-update-mimedb
}
