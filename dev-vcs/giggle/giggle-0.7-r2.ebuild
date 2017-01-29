# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"

inherit autotools gnome2

DESCRIPTION="GTK+ Frontend for GIT"
HOMEPAGE="https://wiki.gnome.org/Apps/giggle"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="eds"

RDEPEND="
	>=dev-vcs/git-1.5
	>=dev-libs/glib-2.30:2
	>=x11-libs/gtk+-3.3.12:3
	>=x11-libs/gtksourceview-3.0:3.0
	>=x11-libs/gdk-pixbuf-2.22.0
	eds? ( gnome-extra/evolution-data-server:= )
	>=x11-libs/vte-0.28:2.91
"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	sys-devel/gettext
	app-text/yelp-tools
	virtual/pkgconfig
	>=dev-util/intltool-0.35
	>=sys-devel/autoconf-2.64
	>=sys-devel/libtool-2
"

src_prepare() {
	eapply "${FILESDIR}/${PN}-0.6.2-gtksourceview-3.8.0.patch"
	eapply "${FILESDIR}/${PN}-0.7-vte-2.91.patch"
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable eds evolution-data-server)
}
