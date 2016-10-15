# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="A MATE specific DBUS service that is used to bring up authentication dialogs"
LICENSE="LGPL-2"
SLOT="0"

IUSE="accountsservice appindicator debug examples gtk3 +introspection"

RDEPEND=">=dev-libs/glib-2.36:2
	>=sys-auth/polkit-0.102:0[introspection?]
	x11-libs/gdk-pixbuf:2[introspection?]
	virtual/libintl:0
	accountsservice? ( sys-apps/accountsservice:0[introspection?] )
	!gtk3? (
		>=x11-libs/gtk+-2.24:2[introspection?]
		appindicator? ( dev-libs/libappindicator:2 )
	)
	gtk3? (
		>=x11-libs/gtk+-3.0:3[introspection?]
		appindicator? ( dev-libs/libappindicator:3 )
	)
	introspection? ( >=dev-libs/gobject-introspection-0.6.2:= )"

DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35:*
	sys-devel/gettext:*
	>=sys-devel/libtool-2.2.6
	virtual/pkgconfig:*
	!<gnome-extra/polkit-gnome-0.102:0"

src_configure() {
	mate_src_configure \
		--disable-static \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_enable accountsservice) \
		$(use_enable appindicator) \
		$(use_enable debug) \
		$(use_enable examples) \
		$(use_enable introspection)
}
