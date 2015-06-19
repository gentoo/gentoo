# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gnome-online-miners/gnome-online-miners-3.14.1.ebuild,v 1.4 2015/03/15 13:31:22 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Crawls through your online content"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeOnlineMiners"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

# libgdata[gnome] needed for goa support
RDEPEND="
	>=dev-libs/libgdata-0.15.2:0=[gnome]
	>=dev-libs/glib-2.35.1:2
	>=net-libs/gnome-online-accounts-3.13.3
	>=media-libs/grilo-0.2.6:0.2
	>=net-libs/libgfbgraph-0.2.2:0.2
	>=net-libs/libzapojit-0.0.2
	>=app-misc/tracker-1:0=
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure --disable-static
}
