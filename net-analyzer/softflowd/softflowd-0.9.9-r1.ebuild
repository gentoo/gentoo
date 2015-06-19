# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/softflowd/softflowd-0.9.9-r1.ebuild,v 1.1 2014/07/17 15:01:44 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="flow-based network traffic analyser capable of Cisco NetFlow data export"
HOMEPAGE="http://www.mindrot.org/projects/softflowd/"
SRC_URI="http://softflowd.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-strip.patch
	epatch "${FILESDIR}"/${P}-_GNU_SOURCE.patch
	eautoreconf
}

src_install() {
	default

	docinto examples
	dodoc collector.pl

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
