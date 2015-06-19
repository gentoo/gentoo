# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtksourceviewmm/gtksourceviewmm-3.12.0.ebuild,v 1.1 2015/05/01 15:39:18 eva Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2 eutils

DESCRIPTION="C++ bindings for gtksourceview"
HOMEPAGE="http://projects.gnome.org/gtksourceviewmm/"

KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"
SLOT="3.0"
LICENSE="LGPL-2.1"

RDEPEND="
	>=dev-cpp/glibmm-2.28:2
	>=dev-cpp/gtkmm-3.2:3.0
	>=x11-libs/gtksourceview-3.12:3.0

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
