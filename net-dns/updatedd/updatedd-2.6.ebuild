# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Dynamic DNS client with plugins for several dynamic dns services"
HOMEPAGE="https://savannah.nongnu.org/projects/updatedd/"
SRC_URI="https://savannah.nongnu.org/download/updatedd/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE=""

RDEPEND=""

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-options.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
	mv "${D}"/usr/share/doc/updatedd "${D}"/usr/share/doc/${PF}
	dodoc AUTHORS
}
