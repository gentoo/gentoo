# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils

IUSE="snmp"

DESCRIPTION="Network interface bandwidth usage, with support for snmp targets"
SRC_URI="http://gael.roualland.free.fr/ifstat/${P}.tar.gz"
HOMEPAGE="http://gael.roualland.free.fr/ifstat/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 hppa ~mips ppc ppc64 sparc x86"

DEPEND="snmp? ( >=net-analyzer/net-snmp-5.0 )"
RDEPEND="${DEPEND}"

DOCS=( HISTORY README TODO )

src_prepare() {
	epatch "${FILESDIR}"/${P}-make.patch
	epatch "${FILESDIR}"/${P}-hardened.patch

	eautoreconf
}

src_configure() {
	econf $(use_with snmp)
}
