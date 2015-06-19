# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/bgpq/bgpq-1.0.9.9.ebuild,v 1.1 2013/06/23 17:55:53 pinkbyte Exp $

EAPI=5

inherit eutils

DESCRIPTION="Generate access-lists for Cisco/Juniper routers"
HOMEPAGE="http://www.lexa.ru/snar/bgpq.html"
SRC_URI="http://snar.spb.ru/prog/bgpq/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-devel/flex"
RDEPEND=""

src_prepare() {
	# Respect CFLAGS and LDFLAGS
	sed -i \
		-e '/^CFLAGS+=/s/+=-g /=/' \
		-e '/^LDADD/s/@LIBS@/@LDFLAGS@ @LIBS@/' \
		Makefile.in || die 'sed on Makefile.in failed'

	epatch_user
}

src_install() {
	dobin bgpq
	doman bgpq.8
	dodoc CHANGES
	dohtml *.html
}
