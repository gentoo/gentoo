# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

DESCRIPTION="A challenge/response-based white-list spam filter"
HOMEPAGE="http://mapson.sourceforge.net/"
SRC_URI="mirror://sourceforge/mapson/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

RDEPEND="virtual/mta"
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_with debug)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS INSTALL NEWS README
	doman doc/mapson.1
	dohtml doc/mapson.html
	dodir /etc/mapson
	insinto /etc/mapson
	newins sample-config mapson.config
	dodir /usr/share/mapson
	insinto /usr/share/mapson
	newins sample-challenge-template challenge-template
	rm -f "${D}"/etc/sample-config
	rm -f "${D}"/usr/share/{mapson.html,sample-challenge-template}
}
