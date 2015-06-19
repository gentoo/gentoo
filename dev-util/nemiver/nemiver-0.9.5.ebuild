# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/nemiver/nemiver-0.9.5.ebuild,v 1.5 2014/03/09 11:56:51 pacho Exp $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2

DESCRIPTION="A gtkmm front end to the GNU Debugger (gdb)"
HOMEPAGE="https://wiki.gnome.org/Apps/Nemiver"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="memoryview"

RDEPEND="
	>=dev-libs/glib-2.16:2
	>=dev-cpp/glibmm-2.30:2
	>=dev-cpp/gtkmm-3:3.0
	>=dev-cpp/gtksourceviewmm-3:3.0
	>=gnome-base/gsettings-desktop-schemas-0.0.1
	>=gnome-base/libgtop-2.19
	>=x11-libs/vte-0.28:2.90
	>=dev-db/sqlite-3:3
	sys-devel/gdb
	dev-libs/boost
	memoryview? ( >=app-editors/ghex-2.90:2 )
"
# FIXME: dynamiclayout needs unreleased stable gdlmm:3
# dynamiclayout? ( >=dev-cpp/gdlmm-3.0:3 )
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--disable-dynamiclayout \
		--disable-static \
		--disable-symsvis \
		--enable-gsettings \
		$(use_enable memoryview) \
		ITSTOOL=$(type -P true)
}
