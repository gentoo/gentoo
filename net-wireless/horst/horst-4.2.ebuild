# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/horst/horst-4.2.ebuild,v 1.1 2015/07/01 05:44:26 xmw Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Small 802.11 wireless LAN analyzer"
HOMEPAGE="http://br1.einfach.org/tech/horst/"
SRC_URI="http://br1.einfach.org/${PN}_dl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +pcap test"

RDEPEND="sys-libs/ncurses
	pcap? ( net-libs/libpcap )"
DEPEND="${RDEPEND}
	test? ( sys-devel/sparse )"

#just semantic tests, no functional tests
RESTRICT=test

src_compile() {
	tc-export CC
	emake PCAP=$(usex pcap 1 0) DEBUG=$(usex debug 1 0)
}

src_install() {
	dosbin ${PN}{,.sh}
	dodoc README TODO
	doman ${PN}.1
}
