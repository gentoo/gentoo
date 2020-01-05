# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 python3_6 )

inherit gnome2 flag-o-matic python-r1

DESCRIPTION="The GNOME Spreadsheet"
HOMEPAGE="http://www.gnumeric.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="+introspection libgda perl python"
# python-loader plugin is python2.7 only
REQUIRED_USE="
	introspection? ( ${PYTHON_REQUIRED_USE} )
	python? ( || ( $(python_gen_useflags -2) ) )"

# Missing gnome-extra/libgnomedb required version in tree
# but its upstream is dead and will be dropped soon.

# lots of missing files, also fails tests due to 80-bit long story
# upstream bug #721556
RESTRICT="test"

RDEPEND="
	app-arch/bzip2
	sys-libs/zlib
	>=dev-libs/glib-2.40.0:2
	>=gnome-extra/libgsf-1.14.33:=
	>=x11-libs/goffice-0.10.42:0.10
	>=dev-libs/libxml2-2.4.12:2
	>=x11-libs/pango-1.24.0:=

	>=x11-libs/gtk+-3.8.7:3
	x11-libs/cairo:=[svg]

	introspection? ( ${PYTHON_DEPS}
	>=dev-libs/gobject-introspection-1:= )
	perl? ( dev-lang/perl:= )
	python? ( $(python_gen_impl_dep '' -2)
		>=dev-python/pygobject-3:3[${PYTHON_USEDEP}] )
	libgda? ( gnome-extra/libgda:5[gtk] )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.5
	app-text/yelp-tools
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
"

src_prepare() {
	# Manage gi overrides ourselves
	sed '/SUBDIRS/ s/introspection//' -i Makefile.{am,in} || die
	gnome2_src_prepare
}

src_configure() {
	if use python ; then
		python_setup -2
	fi
	gnome2_src_configure \
		--disable-static \
		--with-zlib \
		$(use_with libgda gda) \
		$(use_enable introspection) \
		$(use_with perl) \
		$(use_with python)
}

src_install() {
	gnome2_src_install
	if use introspection; then
		python_moduleinto gi.overrides
		python_foreach_impl python_domodule introspection/gi/overrides/Gnm.py
	fi
}
