# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ptpd/ptpd-2.3.0.ebuild,v 1.1 2015/06/12 10:55:53 mgorny Exp $

EAPI=5

inherit autotools eutils flag-o-matic systemd

DESCRIPTION="Precision Time Protocol daemon"
HOMEPAGE="http://ptpd.sf.net"

SRC_URI="mirror://sourceforge/ptpd/${PV}/${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~x86"

LICENSE="BSD"
SLOT="0"
IUSE="debug experimental ntp snmp +statistics"
RDEPEND="
	ntp? ( net-misc/ntp )
	snmp? ( net-analyzer/net-snmp:= )
	net-libs/libpcap:="
DEPEND="${RDEPEND}"

src_prepare() {
	# QA
	epatch "${FILESDIR}/${P}-statistics-clear.patch"
	epatch "${FILESDIR}/${P}-ntpdc.patch"

	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing
	econf \
		--enable-daemon \
		$(use_enable snmp) \
		$(use_enable experimental experimental-options) \
		$(use_enable statistics) \
		$(use_enable ntp ntpdc) \
		$(use_enable debug runtime-debug)
}

src_install() {
	emake install DESTDIR="${D}"

	insinto /etc
	newins "src/ptpd2.conf.minimal" ptpd2.conf

	dodoc "src/ptpd2.conf.default-full"
	dodoc "src/ptpd2.conf.minimal"

	newinitd "${FILESDIR}/ptpd2.rc" ptpd2
	newconfd "${FILESDIR}/ptpd2.confd" ptpd2

	systemd_dounit "${FILESDIR}/ptpd2.service"
}

pkg_postinst() {
	elog "Do not forget to setup correct network interface."
	elog "Change the config file /etc/ptpd2.conf to suit your needs."
}
