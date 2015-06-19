# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/stuntman/stuntman-1.2.6.ebuild,v 1.3 2014/08/10 20:48:00 slyfox Exp $

EAPI=5

DESCRIPTION="STUNTMAN is an open source implementation of the STUN protocol"
HOMEPAGE="http://www.stunprotocol.org"
SRC_URI="http://www.stunprotocol.org/stunserver-${PV}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/boost
	dev-libs/openssl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/stunserver"

src_compile()
{
	emake T=""
}

src_install()
{
	dobin stunclient
	dosbin stunserver
	dodoc HISTORY README
	newinitd "${FILESDIR}/initd.v1" stuntman
}

src_test()
{
	./stuntestcode
}
