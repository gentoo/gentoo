# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ethercard-diag/ethercard-diag-20050321.1g-r1.ebuild,v 1.1 2015/08/07 05:19:56 vapier Exp $

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="low level mii diagnostic tools including mii-diag and etherwake (merge of netdiag/isa-diag)"
HOMEPAGE="ftp://ftp.scyld.com/pub/diag/ ftp://ftp.scyld.com/pub/isa-diag/"
SRC_URI="mirror://gentoo/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!sys-apps/nictools"

src_prepare() {
	# Since the binary is `ether-wake`, make sure the man page is
	# `man ether-wake` and not `man etherwake`. #439504
	sed -i \
		-e 's/ETHERWAKE/ETHER-WAKE/' \
		-e 's/etherwake/ether-wake/' \
		pub/diag/{etherwake.8,Makefile} patches/* || die
	mv pub/diag/ether{,-}wake.8 || die
}

src_compile() {
	tc-export CC AR
	emake
}
