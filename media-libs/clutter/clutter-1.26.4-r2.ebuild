# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic gnome2 virtualx

DESCRIPTION="Clutter is a library for creating graphical user interfaces"
HOMEPAGE="https://wiki.gnome.org/Projects/Clutter"

LICENSE="LGPL-2.1+ FDL-1.1+"
SLOT="1.0"
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="X aqua debug doc egl gtk +introspection test wayland"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	|| ( aqua wayland X )
	wayland? ( egl )
"

# NOTE: glx flavour uses libdrm + >=mesa-7.3
# >=libX11-1.3.1 needed for X Generic Event support
# do not depend on tslib, it does not build and is disabled by default upstream
RDEPEND="
	>=dev-libs/glib-2.53.4:2
	>=dev-libs/atk-2.5.3[introspection?]
	>=dev-libs/json-glib-0.12[introspection?]
	>=media-libs/cogl-1.21.2:1.0=[introspection?,pango,wayland?]
	>=x11-libs/cairo-1.14:=[X?,aqua?,glib]
	>=x11-libs/pango-1.30[X?,introspection?]

	virtual/opengl
	x11-libs/libdrm:=

	egl? (
		>=dev-libs/libinput-0.19.0
		media-libs/cogl[gles2,kms]
		>=dev-libs/libgudev-136
		x11-libs/libxkbcommon[X?,wayland?]
	)
	gtk? ( >=x11-libs/gtk+-3.22.6:3[X?,aqua?,wayland?] )
	introspection? ( >=dev-libs/gobject-introspection-1.39:= )
	X? (
		media-libs/fontconfig
		>=x11-libs/libX11-1.3.1
		x11-libs/libXext
		x11-libs/libXdamage
		>=x11-libs/libXi-1.3
		>=x11-libs/libXcomposite-0.4
	)
	wayland? (
		dev-libs/wayland
		x11-libs/gdk-pixbuf:2
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
	test? ( x11-libs/gdk-pixbuf )
"
BDEPEND="
	dev-util/glib-utils
	>=dev-build/gtk-doc-am-1.20
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	doc? (
		>=dev-util/gtk-doc-1.20
		>=app-text/docbook-sgml-utils-0.6.14[jadetex]
		dev-libs/libxslt
	)
"

src_prepare() {
	# We only need conformance tests, the rest are useless for us
	sed -e 's/^\(SUBDIRS =\).*/\1 accessibility conform/g' \
		-i tests/Makefile.am || die "am tests sed failed"
	sed -e 's/^\(SUBDIRS =\)[^\]*/\1  accessibility conform/g' \
		-i tests/Makefile.in || die "in tests sed failed"

	gnome2_src_prepare
}

src_configure() {
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11
	use wayland || append-cppflags -DGENTOO_GTK_HIDE_WAYLAND

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
		--enable-debug=$(usex debug yes minimum) \
		$(use_enable aqua quartz-backend) \
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
	virtx emake check -C tests/conform
}
