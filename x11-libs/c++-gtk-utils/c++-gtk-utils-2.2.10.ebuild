# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A library containing a number of classes and functions for programming GTK+ programs using C++"
HOMEPAGE="http://cxx-gtk-utils.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/++/xx}/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="+gtk nls static-libs"
SLOT="0"

RDEPEND="
	>=dev-libs/glib-2.26
	gtk? ( x11-libs/gtk+:3 )
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

DOCS=( ChangeLog )

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with gtk) \
		$(use_enable static-libs static) \
		--docdir=/usr/share/doc/${PF} \
		--htmldir=/usr/share/doc/${PF}/html \
		--without-guile
}

src_install() {
	default
	prune_libtool_files
}
