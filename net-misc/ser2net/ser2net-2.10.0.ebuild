# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Serial To Network Proxy"
SRC_URI="mirror://sourceforge/ser2net/${P}.tar.gz"
HOMEPAGE="https://sourceforge.net/projects/ser2net"

KEYWORDS="~amd64 ppc ~x86"
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
