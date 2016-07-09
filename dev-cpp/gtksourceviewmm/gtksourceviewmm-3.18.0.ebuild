# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="C++ bindings for gtksourceview"
HOMEPAGE="https://wiki.gnome.org/Projects/GtkSourceView"

KEYWORDS="amd64 ppc x86"
IUSE="doc"
SLOT="3.0"
LICENSE="LGPL-2.1"

RDEPEND="
	>=dev-cpp/glibmm-2.46.1:2
	>=dev-cpp/gtkmm-3.18.0:3.0
	>=x11-libs/gtksourceview-3.18.0:3.0

	dev-cpp/atkmm
	dev-cpp/cairomm
	dev-cpp/pangomm:1.4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	DOCS="AUTHORS ChangeLog* NEWS README"
	gnome2_src_configure $(use_enable doc documentation)
}
