# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/clutter/clutter-1.18.4.ebuild,v 1.4 2015/02/04 16:09:34 chithanh Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 virtualx

HOMEPAGE="https://wiki.gnome.org/Projects/Clutter"
DESCRIPTION="Clutter is a library for creating graphical user interfaces"

LICENSE="LGPL-2.1+ FDL-1.1+"
SLOT="1.0"
IUSE="debug doc gtk +introspection test" # evdev tslib
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86"

# NOTE: glx flavour uses libdrm + >=mesa-7.3
# XXX: uprof needed for profiling
# >=libX11-1.3.1 needed for X Generic Event support
# XXX: evdev input requires libinput and gudev >= 136
RDEPEND="
	>=dev-libs/glib-2.37.3:2
	>=dev-libs/atk-2.5.3[introspection?]
	>=dev-libs/json-glib-0.12[introspection?]
	>=media-libs/cogl-1.17.5:1.0=[introspection?,pango]
	media-libs/fontconfig
	>=x11-libs/cairo-1.12:=[glib]
	>=x11-libs/pango-1.30[introspection?]

	virtual/opengl
	x11-libs/libdrm:=
	>=x11-libs/libX11-1.3.1
	x11-libs/libXext
	x11-libs/libXdamage
	x11-proto/inputproto
	>=x11-libs/libXi-1.3
	>=x11-libs/libXcomposite-0.4

	gtk? ( >=x11-libs/gtk+-3.3.18:3 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.20
	virtual/pkgconfig
	>=sys-devel/gettext-0.17
	doc? (
		>=dev-util/gtk-doc-1.20
		>=app-text/docbook-sgml-utils-0.6.14[jadetex]
		dev-libs/libxslt )
	test? ( x11-libs/gdk-pixbuf )"

# Tests fail with both swrast and llvmpipe
# They pass under r600g or i965, so the bug is in mesa
#RESTRICT="test"

src_prepare() {
	# We only need conformance tests, the rest are useless for us
	sed -e 's/^\(SUBDIRS =\).*/\1 accessibility conform/g' \
		-i tests/Makefile.am || die "am tests sed failed"
	sed -e 's/^\(SUBDIRS =\)[^\]*/\1  accessibility conform/g' \
		-i tests/Makefile.in || die "in tests sed failed"

	gnome2_src_prepare
}

src_configure() {
	# XXX: Conformance test suite (and clutter itself) does not work under Xvfb
	# (GLX error blabla)
	# XXX: Profiling, coverage disabled for now
	# XXX: What about cex100/egl/osx/wayland/win32 backends?
	# XXX: evdev/tslib input seem to be experimental?
	gnome2_src_configure \
		--enable-xinput \
		--enable-x11-backend=yes \
		--disable-profile \
		--disable-maintainer-flags \
		--disable-gcov \
		--disable-cex100-backend \
		--disable-egl-backend \
		--disable-quartz-backend \
		--disable-wayland-backend \
		--disable-win32-backend \
		--disable-tslib-input \
		--disable-evdev-input \
		$(usex debug --enable-debug=yes --enable-debug=minimum) \
		$(use_enable doc docs) \
		$(use_enable gtk gdk-backend) \
		$(use_enable introspection) \
		$(use_enable test gdk-pixbuf)
}

src_test() {
	Xemake check -C tests/conform
}
