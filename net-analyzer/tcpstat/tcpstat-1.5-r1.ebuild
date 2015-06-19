# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcpstat/tcpstat-1.5-r1.ebuild,v 1.4 2014/12/29 06:57:24 jer Exp $

inherit eutils autotools flag-o-matic

DESCRIPTION="Reports network interface statistics"
SRC_URI="http://www.frenchfries.net/paul/tcpstat/${P}.tar.gz"
HOMEPAGE="http://www.frenchfries.net/paul/tcpstat/"

DEPEND="net-libs/libpcap"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="amd64 ~ppc ~ppc64 sparc x86"

IUSE="ipv6"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-db.patch"
	eautoreconf
}

src_compile() {
	append-flags -Wall -Wextra
	econf $(use_enable ipv6) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "emake install failed"
	dobin src/{catpcap,packetdump} || die "dobin failed"
	dodoc AUTHORS ChangeLog NEWS README doc/Tips_and_Tricks.txt
	newdoc src/README README.src
}
