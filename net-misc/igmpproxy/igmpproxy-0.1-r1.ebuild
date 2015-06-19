# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/igmpproxy/igmpproxy-0.1-r1.ebuild,v 1.3 2013/11/26 22:14:40 pacho Exp $

EAPI=5
inherit linux-info systemd

DESCRIPTION="Multicast Routing Daemon using only IGMP signalling (Internet Group Management Protocol)"
HOMEPAGE="http://sourceforge.net/projects/igmpproxy"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 Stanford"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CONFIG_CHECK="~IP_MULTICAST ~IP_MROUTE"

src_install() {
	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}/${PN}-init.d" ${PN}
	newconfd "${FILESDIR}/${PN}-conf.d" ${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"
}
