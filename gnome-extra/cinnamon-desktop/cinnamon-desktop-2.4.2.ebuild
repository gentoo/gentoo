# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/cinnamon-desktop/cinnamon-desktop-2.4.2.ebuild,v 1.4 2015/03/15 13:24:08 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2 python-any-r1

DESCRIPTION="A collection of libraries and utilites used by Cinnamon"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/cinnamon-desktop/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="0/4" # subslot = libcinnamon-desktop soname version
KEYWORDS="amd64 x86"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/gdk-pixbuf-2.21.3:2[introspection?]
	>=x11-libs/gtk+-3.3.6:3[introspection?]
	>=x11-libs/libXext-1.1
	>=x11-libs/libXrandr-1.3
	x11-libs/cairo:=[X]
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-misc/xkeyboard-config
	>=gnome-base/gsettings-desktop-schemas-3.5.91
	introspection? ( >=dev-libs/gobject-introspection-0.9.7 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.4
	>=dev-util/intltool-0.40.6
	gnome-base/gnome-common
	x11-proto/randrproto
	x11-proto/xproto
	virtual/pkgconfig
"

src_prepare() {
	epatch_user
	eautoreconf

	# Fix intltool unittest
	echo "schemas/org.cinnamon.desktop.keybindings.gschema.xml.in.in" >> po/POTFILES.in
	echo "schemas/org.cinnamon.desktop.keybindings.media-keys.gschema.xml.in.in" >> po/POTFILES.in
	echo "schemas/org.cinnamon.desktop.notifications.gschema.xml.in.in" >> po/POTFILES.in
	echo "schemas/org.cinnamon.desktop.privacy.gschema.xml.in.in" >> po/POTFILES.in

	python_fix_shebang files
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING MAINTAINERS README"

	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection)
}
