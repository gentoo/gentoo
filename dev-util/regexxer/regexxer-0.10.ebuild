# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG=no
inherit autotools eutils gnome2

DESCRIPTION="An interactive tool for performing search and replace operations"
HOMEPAGE="http://regexxer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND=">=dev-cpp/glibmm-2.28
	dev-cpp/gtkmm:3.0
	dev-cpp/gtksourceviewmm:3.0"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	epatch "${FILESDIR}"/${P}-glib-2.32.patch
	epatch "${FILESDIR}"/${P}-sandbox.patch
	eautoreconf
	gnome2_src_prepare
}
