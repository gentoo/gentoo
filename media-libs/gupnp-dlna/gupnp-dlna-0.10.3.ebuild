# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="Library providing DLNA-related functionality for MediaServers"
HOMEPAGE="http://gupnp.org/"

LICENSE="LGPL-2"
SLOT="2.0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.34:2
	>=dev-libs/libxml2-2.5:2
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.11
	virtual/pkgconfig
	introspection? ( $(vala_depend) )
"

src_prepare() {
	# Make doc parallel installable
	cd "${S}"/doc/gupnp-dlna
	sed -e "s/\(DOC_MODULE.*=\).*/\1${PN}-${SLOT}/" \
		-e "s/\(DOC_MAIN_SGML_FILE.*=\).*/\1${PN}-docs-${SLOT}.sgml/" \
		-i Makefile.am Makefile.in || die
	sed -e "s/\(<book.*name=\"\)${PN}/\1${PN}-${SLOT}/" \
		-i html/${PN}.devhelp2 || die
	mv ${PN}-docs{,-${SLOT}}.sgml || die
	mv ${PN}-overrides{,-${SLOT}}.txt || die
	mv ${PN}-sections{,-${SLOT}}.txt || die
	mv ${PN}{,-${SLOT}}.types || die
	mv html/${PN}{,-${SLOT}}.devhelp2

	cd "${S}"

	use introspection && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection)
}

src_install() {
	# Parallel install fails, upstream bug #720053
	MAKEOPTS="${MAKEOPTS} -j1" gnome2_src_install
}
