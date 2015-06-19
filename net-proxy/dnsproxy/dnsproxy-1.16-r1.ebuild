# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/dnsproxy/dnsproxy-1.16-r1.ebuild,v 1.6 2013/03/04 16:41:51 dastergon Exp $

EAPI=4

inherit eutils flag-o-matic

DESCRIPTION="The dnsproxy daemon is a proxy for DNS queries"
HOMEPAGE="http://www.wolfermann.org/dnsproxy.html"
SRC_URI="http://www.wolfermann.org/${P}.tar.gz"

LICENSE="MIT GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/libevent"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-include.patch
	append-flags -D_GNU_SOURCE
}

src_compile() {
	emake ${PN}
}

src_install() {
	dosbin ${PN}
	keepdir /var/empty

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	insinto /etc/${PN}
	newins ${PN}.conf ${PN}.conf.dist

	dodoc README
	doman ${PN}.1
}
