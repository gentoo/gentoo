# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ipband/ipband-0.8.1-r1.ebuild,v 1.3 2014/07/12 17:34:14 jer Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A pcap based IP traffic and bandwidth monitor with configurable reporting and alarm abilities"
HOMEPAGE="http://ipband.sourceforge.net/"
SRC_URI="http://ipband.sourceforge.net/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

DEPEND=">=net-libs/libpcap-0.4"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-postfix.patch

	tc-export CC
}

src_install() {
	dobin ipband
	doman ipband.8
	dodoc CHANGELOG README

	newinitd "${FILESDIR}"/ipband-init ipband

	insinto /etc/
	newins ipband.sample.conf ipband.conf
}
