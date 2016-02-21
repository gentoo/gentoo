# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 flag-o-matic python-single-r1

DESCRIPTION="The GNOME Spreadsheet"
HOMEPAGE="http://www.gnumeric.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE="+introspection libgda perl python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Missing gnome-extra/libgnomedb required version in tree
# but its upstream is dead and will be dropped soon.

# lots of missing files, also fails tests due to 80-bit long story
# upstream bug #721556
RESTRICT="test"

RDEPEND="
	app-arch/bzip2
	sys-libs/zlib
	>=dev-libs/glib-2.38.0:2
	>=gnome-extra/libgsf-1.14.33:=
	>=x11-libs/goffice-0.10.27:0.10
	>=dev-libs/libxml2-2.4.12:2
	>=x11-libs/pango-1.24.0:=

	>=x11-libs/gtk+-3.8.7:3
	x11-libs/cairo:=[svg]

	introspection? ( >=dev-libs/gobject-introspection-1:= )
	perl? ( dev-lang/perl )
	python? ( ${PYTHON_DEPS}
		>=dev-python/pygobject-3:3[${PYTHON_USEDEP}] )
	libgda? ( gnome-extra/libgda:5[gtk] )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--with-zlib \
		$(use_with libgda gda) \
		$(use_enable introspection) \
		$(use_with perl) \
		$(use_with python)
}
