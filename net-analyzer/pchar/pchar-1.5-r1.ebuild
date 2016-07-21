# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

WANT_AUTOCONF=2.1
WANT_AUTOMAKE=none

inherit eutils autotools toolchain-funcs

DESCRIPTION="Internet bandwidth, latency, and loss of links analyzer"
HOMEPAGE="http://www.kitchenlab.org/www/bmah/Software/pchar/"
SRC_URI="http://www.kitchenlab.org/www/bmah/Software/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="ipv6 pcap snmp"

DEPEND=">=dev-libs/openssl-0.9.7
	snmp? ( net-analyzer/net-snmp[ucd-compat(+)] )
	pcap? ( net-libs/libpcap )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-snmp.patch

	eautoreconf
}

src_configure() {
	tc-export CC CXX

	econf --without-suid \
		$(use_with ipv6) \
		$(use_with snmp snmp /usr/lib) \
		$(use_with pcap)
}

src_install() {
	einstall
	dodoc FAQ CHANGES README
}
