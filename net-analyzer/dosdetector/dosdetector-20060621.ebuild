# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/dosdetector/dosdetector-20060621.ebuild,v 1.4 2014/07/11 10:26:23 jer Exp $

EAPI=5
inherit eutils

DESCRIPTION="Tool to analyze and detect suspicious traffic from IP and alert about it"
HOMEPAGE="http://dark-zone.eu/resources/unix/dosdetector/"
SRC_URI="http://dark-zone.eu/resources/unix/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 x86"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-isdigit.patch
}
