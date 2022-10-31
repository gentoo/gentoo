# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info systemd

DESCRIPTION="A multicast routing daemon which uses IGMP forwarding"
HOMEPAGE="https://github.com/pali/igmpproxy"
SRC_URI="https://github.com/pali/${PN}/releases/download/${PV}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2+"
SLOT="0"

CONFIG_CHECK="~IP_MULTICAST ~IP_MROUTE"

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	newinitd "${FILESDIR}"/igmpproxy.initd-r1 igmpproxy
	systemd_dounit "${FILESDIR}"/"${PN}".service

	newconfd "${FILESDIR}"/igmpproxy.confd igmpproxy
}
