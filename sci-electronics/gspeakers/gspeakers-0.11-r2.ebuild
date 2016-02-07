# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"

inherit autotools eutils flag-o-matic gnome2

DESCRIPTION="GTK based loudspeaker enclosure and crossovernetwork designer"
HOMEPAGE="http://gspeakers.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-cpp/gtkmm:2.4
	>=dev-libs/libsigc++-2.6:2
	dev-libs/libxml2:2
	|| (
		sci-electronics/gnucap
		sci-electronics/ngspice
		sci-electronics/spice )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	sed -i -e "s/-O0//" src/Makefile.am
	epatch "${FILESDIR}"/${P}-gcc43.patch
	epatch "${FILESDIR}"/${P}-glib-single-include.patch
	epatch "${FILESDIR}"/${P}-fix-sigc-includes.patch
	epatch "${FILESDIR}"/${P}-c++11.patch
	append-cxxflags '-std=c++11'
	mv configure.in configure.ac || die
	eautoreconf
	gnome2_src_prepare
}
