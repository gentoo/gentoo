# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit autotools base git-2 python

EGIT_REPO_URI="git://github.com/rhult/${PN}.git
	https://github.com/rhult/${PN}.git"
SRC_URI=""

DESCRIPTION="GTK+ bindings for Mac OS X specific tasks"
LICENSE="LGPL-2"
HOMEPAGE="https://live.gnome.org/GTK+/OSX/Integration"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/gtk+:2
		dev-python/pygtk:2"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

src_prepare() {
	# fix the lookup of the codegen tools
	sed -e "s|\$(datadir)/pygtk/2.0|${EPREFIX}/$(python_get_sitedir)/gtk-2.0|g" \
		-i bindings/python/Makefile.am

	eautoreconf
}

src_configure() {
	econf --with-compile-warnings=no
}
