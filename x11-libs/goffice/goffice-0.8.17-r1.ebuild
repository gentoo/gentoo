# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 flag-o-matic

DESCRIPTION="A library of document-centric objects and utilities"
HOMEPAGE="https://git.gnome.org/browse/goffice/"

LICENSE="GPL-2"
SLOT="0.8"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="doc gnome"

# Build fails with -gtk
# FIXME: add lasem to tree
RDEPEND=">=dev-libs/glib-2.16:2
	>=gnome-extra/libgsf-1.14.9
	>=dev-libs/libxml2-2.4.12:2
	>=x11-libs/pango-1.8.1
	>=x11-libs/cairo-1.2[svg]
	x11-libs/libXext
	x11-libs/libXrender
	>=x11-libs/gtk+-2.16:2
	gnome? ( >=gnome-base/gconf-2:2 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1.11 )

	dev-util/gtk-doc-am
	gnome-base/gnome-common"
# eautoreconf requires: gtk-doc-am, gnome-common

pkg_setup() {
	DOCS="AUTHORS BUGS ChangeLog MAINTAINERS NEWS README"

	# Gsettings is still experimental
	if use gnome; then
		G2CONF="${G2CONF} --with-config-backend=gconf"
	else
		G2CONF="${G2CONF} --with-config-backend=keyfile"
	fi

	G2CONF="${G2CONF}
		--without-lasem
		--with-gtk"

	filter-flags -ffast-math
}

src_prepare() {
	# bug #404271, https://bugzilla.gnome.org/show_bug.cgi?id=670316
	epatch "${FILESDIR}/${P}-no-pcre.patch"
	eautoreconf
	gnome2_src_prepare
}
