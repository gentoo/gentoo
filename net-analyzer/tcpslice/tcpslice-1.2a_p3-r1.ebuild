# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

MY_P="${PN}_${PV/_p/}"

DESCRIPTION="Extract and concatenate portions of pcap files"
HOMEPAGE="http://www.tcpdump.org/ https://github.com/the-tcpdump-group/tcpslice"
LICENSE="BSD"
SLOT="0"
SRC_URI="mirror://debian/pool/main/t/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/t/${PN}/${MY_P}-4.debian.tar.gz"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P/_/-}"

src_prepare() {
	epatch \
		"${WORKDIR}"/debian/patches/[0-]* \
		"${FILESDIR}"/${P}-exit.patch
	eautoreconf
}

src_install() {
	dosbin tcpslice
	doman tcpslice.1
	dodoc README
}
