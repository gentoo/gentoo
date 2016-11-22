# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MATE_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit mate multilib python-r1

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="Libraries for the MATE desktop that are not part of the UI"
LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"

IUSE="X debug gtk3 +introspection startup-notification"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.36:2
	x11-libs/cairo:0
	>=x11-libs/gdk-pixbuf-2.4:2[introspection?]
	x11-libs/libX11:0
	>=x11-libs/libXrandr-1.3:0
	virtual/libintl:0
	!gtk3? ( >=x11-libs/gtk+-2.24:2[introspection?] )
	gtk3? ( >=x11-libs/gtk+-3.0:3[introspection?] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
	startup-notification? ( >=x11-libs/startup-notification-0.5:0 )"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40:*
	>=gnome-base/dconf-0.13.4:0
	sys-devel/gettext:*
	>=x11-proto/randrproto-1.3:0
	x11-proto/xproto:0
	virtual/pkgconfig:*"

src_configure() {
	mate_src_configure \
		--enable-mate-about \
		--disable-mate-conf-import \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_with X x) \
		$(use_enable debug) \
		$(use_enable introspection) \
		$(use_enable startup-notification)
}
