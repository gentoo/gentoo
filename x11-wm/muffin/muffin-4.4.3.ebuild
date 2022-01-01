# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils gnome2

DESCRIPTION="Compositing window manager forked from Mutter for use with Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/"
SRC_URI="https://github.com/linuxmint/muffin/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+introspection test xinerama"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

COMMON_DEPEND="
	>=x11-libs/pango-1.2[X,introspection?]
	>=x11-libs/cairo-1.14:=[X]
	x11-libs/gdk-pixbuf:2[introspection?]
	>=x11-libs/gtk+-3.9.12:3[X,introspection?]
	>=dev-libs/glib-2.37.3:2[dbus]
	>=dev-libs/json-glib-1.0
	>=gnome-extra/cinnamon-desktop-4.4:0=
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/libXcomposite-0.3
	>=x11-libs/startup-notification-0.7:=

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxkbcommon
	virtual/opengl

	gnome-extra/zenity

	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	xinerama? ( x11-libs/libXinerama )
"
# needs gtk-doc, not just -am, for gtk-doc.make
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	dev-util/glib-utils
	>=app-text/gnome-doc-utils-0.8
	sys-devel/gettext
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	x11-base/xorg-proto
	test? ( app-text/docbook-xml-dtd:4.5 )
"
RDEPEND="${COMMON_DEPEND}
	!x11-misc/expocity
"

src_prepare() {
	# Fixes from 4.6.0.
	eapply "${FILESDIR}"/muffin-4.4-{gobject-introspection,gir}-fixes.patch

	eautoreconf
	gnome2_src_prepare
}

# Wayland is not supported upstream. Disabled by default in 4.6.0.
src_configure() {
	DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README* *.txt doc/*.txt"
	gnome2_src_configure \
		--disable-static \
		--disable-wayland-egl-server \
		--enable-shape \
		--enable-sm \
		--enable-startup-notification \
		--enable-xsync \
		--enable-verbose-mode \
		--with-libcanberra \
		$(use_enable introspection) \
		$(use_enable xinerama)
}
