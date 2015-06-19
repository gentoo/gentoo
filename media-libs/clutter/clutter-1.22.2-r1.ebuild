# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/clutter/clutter-1.22.2-r1.ebuild,v 1.1 2015/06/11 00:33:29 tetromino Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 virtualx

HOMEPAGE="https://wiki.gnome.org/Projects/Clutter"
DESCRIPTION="Clutter is a library for creating graphical user interfaces"

LICENSE="LGPL-2.1+ FDL-1.1+"
SLOT="1.0"
IUSE="aqua debug doc egl gtk +introspection test wayland +X"
REQUIRED_USE="
	|| ( aqua wayland X )
	wayland? ( egl )
"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

# NOTE: glx flavour uses libdrm + >=mesa-7.3
# >=libX11-1.3.1 needed for X Generic Event support
# do not depend on tslib, it does not build and is disable by default upstream
RDEPEND="
	>=dev-libs/glib-2.39.0:2
	>=dev-libs/atk-2.5.3[introspection?]
	>=dev-libs/json-glib-0.12[introspection?]
	>=media-libs/cogl-1.20.0:1.0=[introspection?,pango,wayland?]
	>=x11-libs/cairo-1.14:=[aqua?,glib]
	>=x11-libs/pango-1.30[introspection?]

	virtual/opengl
	x11-libs/libdrm:=

	egl? (
		>=dev-libs/libinput-0.8
		media-libs/cogl[gles2,kms]
		>=virtual/libgudev-136
		x11-libs/libxkbcommon
	)
	gtk? ( >=x11-libs/gtk+-3.3.18:3[aqua?] )
	introspection? ( >=dev-libs/gobject-introspection-1.39 )
	X? (
		media-libs/fontconfig
		>=x11-libs/libX11-1.3.1
		x11-libs/libXext
		x11-libs/libXdamage
		x11-proto/inputproto
		>=x11-libs/libXi-1.3
		>=x11-libs/libXcomposite-0.4 )
	wayland? (
		dev-libs/wayland
		x11-libs/gdk-pixbuf:2 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	doc? (
		>=dev-util/gtk-doc-1.20
		>=app-text/docbook-sgml-utils-0.6.14[jadetex]
		dev-libs/libxslt )
	test? ( x11-libs/gdk-pixbuf )"

# Tests fail with both swrast and llvmpipe
# They pass under r600g or i965, so the bug is in mesa
#RESTRICT="test"

src_prepare() {
	# From upstream git, 1.22 branch
	epatch "${FILESDIR}"/${P}-touchpad-detection.patch
	epatch "${FILESDIR}"/${P}-cogl-visual-xlib.patch
	epatch "${FILESDIR}"/${P}-clutter_gdk_get_visual.patch
	epatch "${FILESDIR}"/${P}-clutter_gdk_get_visual-2.patch

	# We only need conformance tests, the rest are useless for us
	sed -e 's/^\(SUBDIRS =\).*/\1 accessibility conform/g' \
		-i tests/Makefile.am || die "am tests sed failed"
	sed -e 's/^\(SUBDIRS =\)[^\]*/\1  accessibility conform/g' \
		-i tests/Makefile.in || die "in tests sed failed"

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# XXX: Conformance test suite (and clutter itself) does not work under Xvfb
	# (GLX error blabla)
	# XXX: coverage disabled for now
	# XXX: What about cex100/win32 backends?
	gnome2_src_configure \
		--disable-maintainer-flags \
		--disable-mir-backend \
		--disable-gcov \
		--disable-cex100-backend \
		--disable-win32-backend \
		--disable-tslib-input \
		$(use_enable aqua quartz-backend) \
		$(usex debug --enable-debug=yes --enable-debug=minimum) \
		$(use_enable doc docs) \
		$(use_enable egl egl-backend) \
		$(use_enable egl evdev-input) \
		$(use_enable gtk gdk-backend) \
		$(use_enable introspection) \
		$(use_enable test gdk-pixbuf) \
		$(use_enable wayland wayland-backend) \
		$(use_enable wayland wayland-compositor) \
		$(use_enable X xinput) \
		$(use_enable X x11-backend)
}

src_test() {
	Xemake check -C tests/conform
}
