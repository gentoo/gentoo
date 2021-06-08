# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Generate access-lists for Cisco/Juniper routers, successor of bgpq"
HOMEPAGE="https://github.com/snar/bgpq3/"
SRC_URI="https://github.com/snar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

src_prepare() {
	# Respect CFLAGS
	sed -i \
		-e '/^CFLAGS=/s/-g //' \
		-e '/^CFLAGS=/s/ -O0//' \
		Makefile.in || die 'sed on Makefile.in failed'

	# configure.in in package is actually valid configure.ac
	mv configure.in configure.ac || die

	eapply_user
	eautoreconf
}

src_install() {
	dobin bgpq3
	doman bgpq3.8
	dodoc CHANGES README.md *.html
}
