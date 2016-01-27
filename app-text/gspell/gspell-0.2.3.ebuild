# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala

DESCRIPTION="Spell check library for GTK+ applications"
HOMEPAGE="https://wiki.gnome.org/Projects/gspell"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection vala"
REQUIRED_IUSE="vala? ( introspection )"

RDEPEND="
	>=app-text/enchant-1.6.0
	>=app-text/iso-codes-0.35
	>=dev-libs/glib-2.44:2
	>=x11-libs/gtk+-3.16:3[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.42.0:= )
	vala? ( $(vala_depend) )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.24
	>=dev-util/intltool-0.35.0
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable introspection) \
		$(use_enable vala)
}
