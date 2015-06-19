# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dhcpd-pools/dhcpd-pools-2.21.ebuild,v 1.1 2013/02/19 16:46:30 cardoe Exp $

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
