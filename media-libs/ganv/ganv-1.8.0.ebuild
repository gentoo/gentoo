# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE='threads(+)'
inherit flag-o-matic waf-utils python-any-r1

DESCRIPTION="A GTK+ widget for interactive graph-like environments"
HOMEPAGE="http://drobilla.net/software/ganv/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+fdgl +graphviz introspection nls"

RDEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	x11-libs/gtk+:2
	graphviz? ( media-gfx/graphviz[gtk] )
	introspection? (
		app-text/yelp-tools
		dev-libs/gobject-introspection:=[doctool] )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/glib-utils
	nls? ( virtual/libintl )
"

src_configure() {
	append-cxxflags -std=c++11
	waf-utils_src_configure \
		$(use graphviz || echo "--no-graphviz") \
		$(use fdgl || echo "--no-fdgl") \
		$(use nls || echo "--no-nls") \
		$(use introspection && echo "--gir")
}
