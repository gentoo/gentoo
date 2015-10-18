# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

DESCRIPTION="A library of document-centric objects and utilities"
HOMEPAGE="https://git.gnome.org/browse/goffice/"

LICENSE="GPL-2"
SLOT="0.8"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="gnome"

# Build fails with -gtk
# FIXME: add lasem to tree
RDEPEND="
	>=dev-libs/glib-2.16:2
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
	dev-util/gtk-doc-am

	gnome-base/gnome-common
"
# eautoreconf requires: gnome-common

src_prepare() {
	# bug #404271, https://bugzilla.gnome.org/show_bug.cgi?id=670316
	epatch "${FILESDIR}/${P}-no-pcre.patch"

	mv configure.in configure.ac || die
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	local myconf
	DOCS="AUTHORS BUGS ChangeLog MAINTAINERS NEWS README"

	# Gsettings is still experimental
	if use gnome; then
		myconf="${myconf} --with-config-backend=gconf"
	else
		myconf="${myconf} --with-config-backend=keyfile"
	fi

	gnome2_src_configure \
		--without-lasem \
		--with-gtk \
		${myconf}
}
