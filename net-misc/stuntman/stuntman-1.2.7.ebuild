# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/stuntman/stuntman-1.2.7.ebuild,v 1.1 2015/06/04 22:28:52 chainsaw Exp $

EAPI=5

DESCRIPTION="STUNTMAN is an open source implementation of the STUN protocol"
HOMEPAGE="http://www.stunprotocol.org"
SRC_URI="http://www.stunprotocol.org/stunserver-${PV}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/boost
	dev-libs/openssl:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/stunserver"

src_compile() {
	emake T=""
}

src_install() {
	dobin stunclient
	dosbin stunserver
	dodoc HISTORY README
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
}

src_test() {
	./stuntestcode
}
