# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gspeakers/gspeakers-0.11-r1.ebuild,v 1.9 2012/10/21 10:28:01 pacho Exp $

EAPI=4
inherit eutils gnome2 autotools

DESCRIPTION="GTK based loudspeaker enclosure and crossovernetwork designer"
HOMEPAGE="http://gspeakers.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-cpp/gtkmm:2.4
	dev-libs/libxml2:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
RDEPEND="${RDEPEND}
	|| ( sci-electronics/gnucap
		sci-electronics/ngspice
		sci-electronics/spice )"

DOCS="AUTHORS ChangeLog NEWS README* TODO"

src_prepare() {
	sed -i -e "s/-O0//" src/Makefile.am
	epatch "${FILESDIR}"/${P}-gcc43.patch
	epatch "${FILESDIR}"/${P}-glib-single-include.patch
	eautoreconf
	gnome2_src_prepare
}
