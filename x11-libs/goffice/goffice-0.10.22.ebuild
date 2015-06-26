# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/goffice/goffice-0.10.22.ebuild,v 1.3 2015/06/26 09:24:03 ago Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="A library of document-centric objects and utilities"
HOMEPAGE="http://git.gnome.org/browse/goffice/"

LICENSE="GPL-2"
SLOT="0.10"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="+introspection"

# Build fails with -gtk
# FIXME: add lasem to tree
RDEPEND="
	>=app-text/libspectre-0.2.6:=
	>=dev-libs/glib-2.38.0:2
	dev-libs/libxslt
	>=gnome-base/librsvg-2.22:2
	>=gnome-extra/libgsf-1.14.24:=[introspection?]
	>=dev-libs/libxml2-2.4.12:2
	>=x11-libs/pango-1.24:=
	>=x11-libs/cairo-1.10:=[svg]
	x11-libs/libXext:=
	x11-libs/libXrender:=
	>=x11-libs/gdk-pixbuf-2.22:2
	>=x11-libs/gtk+-3.8.7:3
	introspection? (
		>=dev-libs/gobject-introspection-1:=
		>=gnome-extra/libgsf-1.14.23:= )
"
DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/perl-Getopt-Long
	virtual/perl-IO-Compress
	virtual/perl-Compress-Raw-Zlib
	>=dev-util/gtk-doc-am-1.12
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"
# eautoreconf requires:
# gnome-base/gnome-common

src_configure() {
	gnome2_src_configure \
		--without-lasem \
		--with-gtk \
		--with-config-backend=gsettings \
		$(use_enable introspection)
}
