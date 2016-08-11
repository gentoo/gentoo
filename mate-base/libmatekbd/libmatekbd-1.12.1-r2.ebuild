# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="MATE keyboard configuration library"
LICENSE="LGPL-2"
SLOT="0"

IUSE="X gtk3 +introspection test"

RDEPEND=">=dev-libs/glib-2.36:2
	x11-libs/cairo:0
	>=x11-libs/gdk-pixbuf-2.24:2
	x11-libs/libX11:0
	>=x11-libs/libxklavier-5.0:0
	x11-libs/pango:0
	virtual/libintl:0
	!gtk3? ( >=x11-libs/gtk+-2.24:2[introspection?] )
	gtk3? ( >=x11-libs/gtk+-3.0:3[introspection?] )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )"

DEPEND="${RDEPEND}
	sys-devel/gettext:*
	>=dev-util/intltool-0.50.1:*
	virtual/pkgconfig:*"

src_configure() {
	mate_src_configure \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_with X x) \
		$(use_enable introspection) \
		$(use_enable test tests)
}
