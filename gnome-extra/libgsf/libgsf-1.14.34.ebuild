# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="The GNOME Structured File Library"
HOMEPAGE="https://developer.gnome.org/gsf/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/114" # libgsf-1.so version
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ~ppc ppc64 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="bzip2 gtk +introspection"

RDEPEND="
	>=dev-libs/glib-2.26:2
	>=dev-libs/libxml2-2.4.16:2
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	gtk? ( x11-libs/gtk+:2 )
	introspection? ( >=dev-libs/gobject-introspection-1 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	>=dev-util/intltool-0.35.0
	dev-libs/gobject-introspection-common
	virtual/pkgconfig
"

src_configure() {
	DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"
	gnome2_src_configure \
		--disable-static \
		$(use_with bzip2 bz2) \
		$(use_enable introspection) \
		$(use_with gtk gdk-pixbuf)
}
