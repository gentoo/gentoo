# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/bijiben/bijiben-3.16.2.ebuild,v 1.2 2015/06/13 09:59:02 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Note editor designed to remain simple to use"
HOMEPAGE="https://wiki.gnome.org/Apps/Bijiben"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# zeitgeist is optional but automagic
RDEPEND="
	>=app-misc/tracker-1:=
	>=dev-libs/glib-2.28:2
	dev-libs/libxml2
	>=gnome-extra/evolution-data-server-3.13.90:=
	>=mail-client/evolution-3
	gnome-extra/zeitgeist
	net-libs/gnome-online-accounts
	net-libs/webkit-gtk:3
	sys-apps/util-linux
	>=x11-libs/gtk+-3.11.4:3
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
"
#	app-text/yelp-tools

src_configure() {
	gnome2_src_configure \
		ITSTOOL="$(type -P true)" \
		--disable-update-mimedb
}
