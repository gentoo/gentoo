# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/reaver/reaver-1.4.ebuild,v 1.1 2012/05/15 19:39:11 maksbotan Exp $

EAPI=4

AUTOTOOLS_IN_SOURCE_BUILD="1"

inherit autotools-utils

DESCRIPTION="Brute force attack against Wifi Protected Setup"
HOMEPAGE="http://code.google.com/p/reaver-wps/"
SRC_URI="http://reaver-wps.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/libpcap
		dev-db/sqlite:3"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src"

src_install() {
	dobin wash reaver

	insinto "/etc/reaver"
	doins reaver.db

	doman ../docs/reaver.1.gz
	dodoc ../docs/README ../docs/README.REAVER ../docs/README.WASH
}
