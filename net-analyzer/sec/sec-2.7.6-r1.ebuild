# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/sec/sec-2.7.6-r1.ebuild,v 1.1 2015/02/15 09:59:01 jer Exp $

EAPI=5

DESCRIPTION="Simple Event Correlator"
HOMEPAGE="http://simple-evcorr.sourceforge.net/"
SRC_URI="mirror://sourceforge/simple-evcorr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux"

RDEPEND=">=dev-lang/perl-5.8.0"

src_install() {
	dobin sec

	dodoc ChangeLog README
	docinto contrib
	dodoc contrib/{itostream.c,convert.pl,swatch2sec.pl}

	newman sec.man sec.1

	newinitd "${FILESDIR}"/sec.init.d sec
	newconfd "${FILESDIR}"/sec.conf.d sec
}
