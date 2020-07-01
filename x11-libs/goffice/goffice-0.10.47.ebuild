# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org libtool

DESCRIPTION="A library of document-centric objects and utilities"
HOMEPAGE="https://gitlab.gnome.org/GNOME/goffice/"

LICENSE="GPL-2"
SLOT="0.10"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="+introspection"

# FIXME: add lasem to tree
RDEPEND="
	>=app-text/libspectre-0.2.6:=
	>=dev-libs/glib-2.40.0:2
	>=dev-libs/libxml2-2.4.12:2
	dev-libs/libxslt
	>=gnome-base/librsvg-2.22:2
	>=gnome-extra/libgsf-1.14.24:=[introspection?]
	>=x11-libs/cairo-1.10:=[svg]
	>=x11-libs/gdk-pixbuf-2.22:2
	>=x11-libs/gtk+-3.20:3
	>=x11-libs/pango-1.24:=
	x11-libs/libXext:=
	x11-libs/libXrender:=
	introspection? (
		>=dev-libs/gobject-introspection-1:=
		>=gnome-extra/libgsf-1.14.23:=
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.12
	>=dev-util/intltool-0.35
	virtual/perl-Compress-Raw-Zlib
	virtual/perl-Getopt-Long
	virtual/perl-IO-Compress
	virtual/pkgconfig"

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	econf \
		--disable-gtk-doc \
		--disable-maintainer-mode \
		--without-lasem \
		--with-gtk \
		--with-config-backend=gsettings \
		$(use_enable introspection)
}

src_install() {
	default
	dodoc MAINTAINERS

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
