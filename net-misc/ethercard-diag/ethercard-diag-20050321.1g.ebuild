# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ethercard-diag/ethercard-diag-20050321.1g.ebuild,v 1.2 2008/04/14 06:00:40 vapier Exp $

inherit toolchain-funcs

DESCRIPTION="low level mii diagnostic tools including mii-diag and etherwake (merge of netdiag/isa-diag)"
HOMEPAGE="ftp://ftp.scyld.com/pub/diag/ ftp://ftp.scyld.com/pub/isa-diag/"
SRC_URI="mirror://gentoo/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!sys-apps/nictools"

src_compile() {
	tc-export CC AR
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodir /sbin
	mv "${D}"/usr/sbin/{mii-diag,ether-wake} "${D}"/sbin/ || die
}
