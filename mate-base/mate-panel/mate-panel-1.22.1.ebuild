# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="The MATE panel"
LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"

IUSE="X +introspection wayland"

RDEPEND="
	dev-libs/atk
	>=dev-libs/dbus-glib-0.80:0
	>=dev-libs/glib-2.50:2
	>=dev-libs/libmateweather-1.17.0
	dev-libs/libxml2:2
	>=gnome-base/dconf-0.13.4
	>=gnome-base/librsvg-2.36.2:2
	>=mate-base/mate-desktop-1.17.0
	>=mate-base/mate-menus-1.21.0
	>=sys-apps/dbus-1.1.2
	>=x11-libs/cairo-1
	>=x11-libs/gdk-pixbuf-2.25.2:2
	>=x11-libs/gtk+-3.22:3[introspection?]
	x11-libs/libICE
	x11-libs/libSM
	>=x11-libs/libwnck-3.4.6:3[introspection?]
	x11-libs/libX11
	>=x11-libs/pango-1.15.4:0[introspection?]
	x11-libs/libXau
	>=x11-libs/libXrandr-1.3
	virtual/libintl
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
	wayland? ( dev-libs/wayland )"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools
	>=dev-lang/perl-5:=
	dev-util/glib-utils
	dev-util/gdbus-codegen
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	mate_src_configure \
		--libexecdir=/usr/libexec/mate-applets \
		--disable-deprecation-flags \
		$(use_enable X x11) \
		$(use_enable introspection) \
		$(use_enable wayland)
}
