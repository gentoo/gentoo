# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/portmon/portmon-2.0.ebuild,v 1.11 2014/08/10 21:00:25 slyfox Exp $

EAPI=5

DESCRIPTION="Portmon is a network service monitoring daemon"
HOMEPAGE="http://aboleo.net/software/portmon/"
SRC_URI="${HOMEPAGE}downloads/${P}.tar.gz"

KEYWORDS="~amd64 ~ppc x86"
SLOT="0"
LICENSE="GPL-2"

src_configure() {
	econf --sysconfdir=/etc/portmon
}

src_install() {
	into /usr
	dosbin src/portmon

	doman extras/portmon.8

	insinto /etc/portmon
	doins extras/portmon.hosts.sample
	dodoc AUTHORS BUGS README

	newinitd "${FILESDIR}"/portmon.init portmon
}
