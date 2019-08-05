# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="GLib/GObject wrapper for the SkyDrive and Hotmail REST APIs"
HOMEPAGE="https://git.gnome.org/browse/libzapojit"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="+introspection"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=net-libs/libsoup-2.38:2.4
	dev-libs/json-glib
	net-libs/rest
	net-libs/gnome-online-accounts

	introspection? ( >=dev-libs/gobject-introspection-1.30.0 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.11
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
"
# eautoreconf needs:
#	gnome-base/gnome-common:3

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection)
}
