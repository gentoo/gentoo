# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 mono

DESCRIPTION="Desktop note-taking application"
HOMEPAGE="https://projects.gnome.org/tomboy/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="eds test"

RDEPEND="
	app-text/gtkspell:2
	dev-dotnet/gconf-sharp:2
	dev-dotnet/gtk-sharp:2
	dev-dotnet/mono-addins[gtk]
	dev-dotnet/dbus-sharp
	dev-dotnet/dbus-sharp-glib
	dev-lang/mono
	dev-libs/atk:=
	gnome-base/gconf:2
	x11-libs/gtk+:2
	eds? ( dev-libs/gmime:2.6[mono] )
"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	app-text/rarian
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
"

src_prepare() {
	sed	\
		-e "s:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g" \
		-i configure.in || die

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-panel-applet \
		--disable-galago \
		--disable-update-mimedb \
		$(use_enable eds evolution) \
		$(use_enable test tests)
}

src_compile() {
	# Not parallel build safe due upstream bug #631546
	MAKEOPTS="${MAKEOPTS} -j1" gnome2_src_compile
}
