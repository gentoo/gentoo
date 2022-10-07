# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="GLib/GObject wrapper for the SkyDrive and Hotmail REST APIs"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libzapojit"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv ~sparc x86"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=net-libs/libsoup-2.38:2.4
	dev-libs/json-glib
	net-libs/rest:0.7
	net-libs/gnome-online-accounts

	introspection? ( >=dev-libs/gobject-introspection-1.30.0 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/gtk-doc-am-1.11
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
"
# eautoreconf needs:
#	gnome-base/gnome-common:3

src_configure() {
	gnome2_src_configure \
		$(use_enable introspection)
}
