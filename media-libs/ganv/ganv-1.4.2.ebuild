# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'
inherit eutils waf-utils python-any-r1

DESCRIPTION="A GTK+ widget for interactive graph-like environments"
HOMEPAGE="http://drobilla.net/software/ganv/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+fdgl +graphviz introspection nls"

RDEPEND="dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	x11-libs/gtk+:2
	graphviz? ( media-gfx/graphviz[gtk] )
	introspection? ( app-text/yelp-tools
		dev-libs/gobject-introspection[doctool] )"
DEPEND="${RDEPEND}
	nls? ( virtual/libintl )"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-fdgl.patch
}

src_configure() {
	waf-utils_src_configure \
		$(use graphviz || echo "--no-graphviz") \
		$(use fdgl || echo "--no-fdgl") \
		$(use nls || echo "--no-nls") \
		$(use introspection && echo "--gir")
}
