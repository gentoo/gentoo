# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="ISC dhcpd lease analysis and reporting"
HOMEPAGE="http://dhcpd-pools.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="dev-libs/uthash
	doc? ( app-doc/doxygen )"
RDEPEND=""

src_configure() {
	econf $(use_enable doc doxygen) --with-dhcpd-conf=/etc/dhcp/dhcpd.conf
}
