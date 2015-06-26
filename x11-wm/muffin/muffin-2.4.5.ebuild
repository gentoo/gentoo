# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/muffin/muffin-2.4.5.ebuild,v 1.3 2015/06/26 09:24:43 ago Exp $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2 python-any-r1

DESCRIPTION="Compositing window manager forked from Mutter for use with Cinnamon"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/muffin/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+introspection test xinerama"
KEYWORDS="amd64 x86"

COMMON_DEPEND="
	>=x11-libs/pango-1.2[X,introspection?]
	>=x11-libs/cairo-1.10:=[X]
	x11-libs/gdk-pixbuf:2[introspection?]
	>=x11-libs/gtk+-3.3.7:3[X,introspection?]
	>=dev-libs/glib-2.25.10:2[dbus]
	>=gnome-extra/cinnamon-desktop-2.3:0=[introspection?]
	>=gnome-base/gsettings-desktop-schemas-3.3.0[introspection?]
	>=media-libs/clutter-1.9.10:1.0=[introspection?]
	>=media-libs/cogl-1.9.6:1.0=[introspection?]
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/libXcomposite-0.2
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
	virtual/opengl

	gnome-extra/zenity

	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	>=app-text/gnome-doc-utils-0.8
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	test? ( app-text/docbook-xml-dtd:4.5 )
	xinerama? ( x11-proto/xineramaproto )
	x11-proto/xextproto
	x11-proto/xproto
"
RDEPEND="${COMMON_DEPEND}
	!x11-misc/expocity
"

src_prepare() {
	epatch_user
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README* *.txt doc/*.txt"
	gnome2_src_configure \
		--disable-static \
		--enable-shape \
		--enable-sm \
		--enable-startup-notification \
		--enable-xsync \
		--enable-verbose-mode \
		--with-libcanberra \
		$(use_enable introspection) \
		$(use_enable xinerama)
}
