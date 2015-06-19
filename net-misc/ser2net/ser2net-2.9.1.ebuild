# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ser2net/ser2net-2.9.1.ebuild,v 1.3 2015/04/19 09:30:30 pacho Exp $

EAPI=5

DESCRIPTION="Serial To Network Proxy"
SRC_URI="mirror://sourceforge/ser2net/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/ser2net"

KEYWORDS="~amd64 ppc x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="tcpd? ( sys-apps/tcp-wrappers )"
RDEPEND="${DEPEND}"

IUSE="tcpd"

src_configure() {
	econf $(use_with tcpd tcp-wrappers) --with-uucp-locking
}

src_install () {
	default

	insinto /etc
	newins ${PN}.conf ${PN}.conf.dist

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
}
