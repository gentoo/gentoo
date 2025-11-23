# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Serial To Network Proxy"
HOMEPAGE="https://sourceforge.net/projects/ser2net"
SRC_URI="https://downloads.sourceforge.net/ser2net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="tcpd"

DEPEND="tcpd? ( sys-apps/tcp-wrappers )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with tcpd tcp-wrappers) --with-uucp-locking
}

src_install() {
	default

	insinto /etc
	newins ${PN}.conf ${PN}.conf.dist

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
}
