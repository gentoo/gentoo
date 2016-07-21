# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs git-r3

DESCRIPTION="Small 802.11 wireless LAN analyzer"
HOMEPAGE="http://br1.einfach.org/tech/horst/"
EGIT_REPO_URI="https://github.com/br101/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug +pcap test"

RDEPEND="sys-libs/ncurses:0
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
	dodoc README.md
	doman ${PN}.1
	insinto /etc
	doins ${PN}.conf
}
