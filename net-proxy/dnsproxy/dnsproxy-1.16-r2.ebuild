# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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
	eapply -p0 "${FILESDIR}"/${P}-include.patch
	append-cppflags -D_GNU_SOURCE

	default
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
