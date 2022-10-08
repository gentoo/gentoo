# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit autotools gnome.org python-r1 xdg

DESCRIPTION="The GNOME Spreadsheet"
HOMEPAGE="http://www.gnumeric.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+introspection libgda perl"
REQUIRED_USE="introspection? ( ${PYTHON_REQUIRED_USE} )"

# Missing gnome-extra/libgnomedb required version in tree
# but its upstream is dead and will be dropped soon.

# lots of missing files, also fails tests due to 80-bit long story
# upstream bug #721556
RESTRICT="test"

# Gnumeric has two python components
# 1. The python loader for loading python-based plugins.
#    This component is pure python 2 and a port "is not currently being worked on".
# 2. The python gobject-based introspection API. This component is compatible
#    with python 3.
# Component 1. can only be re-enabled once someone has ported the upstream
# codebase to python 3.
# https://gitlab.gnome.org/GNOME/gnumeric/issues/419#note_618852
RDEPEND="
	app-arch/bzip2
	sys-libs/zlib
	>=dev-libs/glib-2.40.0:2
	>=gnome-extra/libgsf-1.14.33:=
	>=x11-libs/goffice-0.10.51:0.10[introspection?]
	>=dev-libs/libxml2-2.4.12:2
	>=x11-libs/pango-1.24.0:=

	>=x11-libs/gtk+-3.8.7:3
	x11-libs/cairo:=[svg(+)]

	introspection? (
		${PYTHON_DEPS}
		>=dev-libs/gobject-introspection-1:=
	)
	perl? ( dev-lang/perl:= )
	libgda? ( gnome-extra/libgda:5[gtk] )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xml-dtd:4.5
	app-text/yelp-tools
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig"

src_prepare() {
	default

	# Manage gi overrides ourselves
	sed '/SUBDIRS/ s/introspection//' -i Makefile.{am,in} || die

	# Changed from 'elibtoolize' for bug # 791610
	eautoreconf
}

src_configure() {
	econf \
		--disable-gtk-doc \
		--disable-maintainer-mode \
		--disable-schemas-compile \
		--disable-static \
		--without-psiconv \
		--without-python \
		--with-zlib \
		$(use_with libgda gda) \
		$(use_enable introspection) \
		$(use_with perl)
}

src_install() {
	default
	dodoc HACKING MAINTAINERS

	if use introspection; then
		python_moduleinto gi.overrides
		python_foreach_impl python_domodule introspection/gi/overrides/Gnm.py
	fi

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
