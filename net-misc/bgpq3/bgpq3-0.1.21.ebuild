# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Generate access-lists for Cisco/Juniper routers, successor of bgpq"
HOMEPAGE="http://snar.spb.ru/prog/bgpq3/"
SRC_URI="http://snar.spb.ru/prog/bgpq3/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

src_prepare() {
	# Respect CFLAGS and LDFLAGS
	sed -i \
		-e '/^CFLAGS=/s/-g //' \
		-e '/^CFLAGS=/s/ -O0//' \
		Makefile.in || die 'sed on Makefile.in failed'

	epatch_user
}

src_install() {
	dobin bgpq3
	doman bgpq3.8
	dodoc CHANGES
	dohtml *.html
}
