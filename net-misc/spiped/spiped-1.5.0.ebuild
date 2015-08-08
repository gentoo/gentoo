# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="secure pipe daemon"
HOMEPAGE="http://www.tarsnap.com/spiped.html"
SRC_URI="http://www.tarsnap.com/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/openssl:*"
RDEPEND="${DEPEND}"

src_install() {
	dobin spipe/spipe
	dosbin spiped/spiped

	doman spipe/spipe.1 spiped/spiped.1

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	dodir etc/spiped
}

pkg_postinst() {
	elog
	elog "You will need to configure spiped via its"
	elog "configuration file located in /etc/conf.d/."
	elog
	elog "Please have a look at this file prior to starting up spiped!"
	elog
}
