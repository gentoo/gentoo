# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/libgxps/libgxps-0.2.2.ebuild,v 1.17 2015/01/07 19:53:13 pacho Exp $

EAPI="5"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"

inherit gnome2

DESCRIPTION="Library for handling and rendering XPS documents"
HOMEPAGE="https://wiki.gnome.org/Projects/libgxps"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="+introspection jpeg lcms static-libs tiff"

RDEPEND="
	>=app-arch/libarchive-2.8
	>=dev-libs/glib-2.24:2
	media-libs/freetype:2
	media-libs/libpng:0
	>=x11-libs/cairo-1.10[svg]
	introspection? ( >=dev-libs/gobject-introspection-0.10.1 )
	jpeg? ( virtual/jpeg )
	lcms? ( media-libs/lcms:2 )
	tiff? ( media-libs/tiff[zlib] )
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/gtk-doc-am
	virtual/pkgconfig
"

# There is no automatic test suite, only an interactive test application
RESTRICT="test"

src_configure() {
	gnome2_src_configure \
		--enable-man \
		--disable-test \
		$(use_enable introspection) \
		$(use_with jpeg libjpeg) \
		$(use_with lcms liblcms2) \
		$(use_enable static-libs static) \
		$(use_with tiff libtiff)
}
