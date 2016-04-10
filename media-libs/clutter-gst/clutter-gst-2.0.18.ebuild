# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-any-r1

HOMEPAGE="https://blogs.gnome.org/clutter/"
DESCRIPTION="GStreamer integration library for Clutter"

LICENSE="LGPL-2.1+"
SLOT="2.0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples +introspection"

# FIXME: Support for gstreamer-basevideo-0.10 (HW decoder support) is automagic
COMMON_DEPEND="
	>=dev-libs/glib-2.20:2
	>=media-libs/clutter-1.6.0:1.0=[introspection?]
	>=media-libs/cogl-1.10:1.0=[introspection?]
	>=media-libs/gstreamer-1.2.0:1.0[introspection?]
	>=media-libs/gst-plugins-bad-1.2.0:1.0
	>=media-libs/gst-plugins-base-1.2.0:1.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.6.8:= )
"
# uses goom from gst-plugins-good
RDEPEND="${COMMON_DEPEND}
	>=media-libs/gst-plugins-good-1.2.0:1.0
"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	>=dev-util/gtk-doc-am-1.8
	virtual/pkgconfig
"

src_prepare() {
	# Make doc parallel installable
	cd "${S}"/doc/reference
	sed -e "s/\(DOC_MODULE.*=\).*/\1${PN}-${SLOT}/" \
		-e "s/\(DOC_MAIN_SGML_FILE.*=\).*/\1${PN}-docs-${SLOT}.sgml/" \
		-i Makefile.am Makefile.in || die
	sed -e "s/\(<book.*name=\"\)clutter-gst/\1${PN}-${SLOT}/" \
		-i html/clutter-gst.devhelp2 || die
	mv clutter-gst-docs{,-${SLOT}}.sgml || die
	mv clutter-gst-overrides{,-${SLOT}}.txt || die
	mv clutter-gst-sections{,-${SLOT}}.txt || die
	mv clutter-gst{,-${SLOT}}.types || die
	mv html/clutter-gst{,-${SLOT}}.devhelp2

	cd "${S}"
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-maintainer-flags \
		$(use_enable introspection)
}

src_compile() {
	# Clutter tries to access dri without userpriv, upstream bug #661873
	# Massive failure of a hack, see bug 360219, bug 360073, bug 363917
	unset DISPLAY
	gnome2_src_compile
}

src_install() {
	gnome2_src_install

	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins examples/{*.c,*.png,README}
	fi
}
